Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE46B001A
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 08:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCHHp0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Mar 2023 02:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCHHpZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Mar 2023 02:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5BC911E5
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 23:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678261479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LoVcvJyVYNZQgjrYfBlIMLAPlM+tY6ZIFyFH/nFof5A=;
        b=XMc+Q30KxBS8LZ11EwDJ4q8wk04XeXHb3YoAhUMgm3FdC8VjfI9XB4n/hM2vmF5+NRYEIH
        9oEU0k4IVafDOQhJUmlCT7ANR65SrI7DCuJf9yhu7Co0TaaotrREP3LjhJJi7mLvyRy008
        trnHurIPbNRVUzFGGHyUSb3hN5cj4uo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-AHxDAfxrM9y0kA_Mp-N38w-1; Wed, 08 Mar 2023 02:44:37 -0500
X-MC-Unique: AHxDAfxrM9y0kA_Mp-N38w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65D3B3C0ED59;
        Wed,  8 Mar 2023 07:44:35 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11AD1C15BA0;
        Wed,  8 Mar 2023 07:44:31 +0000 (UTC)
Date:   Wed, 8 Mar 2023 15:44:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, ming.lei@redhat.com
Subject: Re: [PATCH V2 06/17] block: ublk_drv: mark device as LIVE before
 adding disk
Message-ID: <ZAg82vq4bDC64YH/@ovpn-8-16.pek2.redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <20230307141520.793891-7-ming.lei@redhat.com>
 <3e5c7542-e4ad-202f-6dbb-fdea37bd62d7@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5c7542-e4ad-202f-6dbb-fdea37bd62d7@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 08, 2023 at 11:48:15AM +0800, Ziyang Zhang wrote:
> On 2023/3/7 22:15, Ming Lei wrote:
> > IO can be started before add_disk() returns, such as reading parititon table,
> > then the monitor work should work for making forward progress.
> > 
> > So mark device as LIVE before adding disk, meantime change to
> > DEAD if add_disk() fails.
> > 
> > Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> 
> Hi Ming,
> 
> Without this patch, if we fail to read partition table(Could this
> happen?)and EIO is returned, then START_DEV may hang forever, right?
> I may have encountered such error before and I think this bug is introduced
> by:
> bbae8d1f526b(ublk_drv: consider recovery feature in aborting mechanism)
> which change the behavior of monitor_work. So shall we add a fixes tag, such
> as:
> Fixes: bbae8d1f526b("ublk_drv: consider recovery feature in aborting mechanism")

Even without the above commit, monitor work still may not be started
because of ub->dev_info.state == UBLK_S_DEV_DEAD.

thanks, 
Ming

