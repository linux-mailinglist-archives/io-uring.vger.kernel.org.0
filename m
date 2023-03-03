Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268726A8FA3
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 04:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCCDC7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Mar 2023 22:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCCDCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Mar 2023 22:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2427570A5
        for <io-uring@vger.kernel.org>; Thu,  2 Mar 2023 19:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677812524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XdamV2Uqp74frt8HUiRoWRCldVodbU/8sCppa7dCDOo=;
        b=fznLQF58HlqQhZkKNRVWOUtv79Gt+m5jkFnNPbF3QbfneE5X8OVGXGrmISbgJnO6t0otj/
        qt12wBMlDYunwQAatQLM3R5/SIommR1ebkPVkxvyuWcAMSGZgZ3mJafzVDD53S3Rlvva68
        DlHHNT+8pNAr4baYhkMJRipNHAUYhk0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139--NpgzR2sNw29JG4ZeFAJIw-1; Thu, 02 Mar 2023 22:02:00 -0500
X-MC-Unique: -NpgzR2sNw29JG4ZeFAJIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B519101A52E;
        Fri,  3 Mar 2023 03:02:00 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4B5F1121318;
        Fri,  3 Mar 2023 03:01:57 +0000 (UTC)
Date:   Fri, 3 Mar 2023 11:01:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] io_uring: add IORING_OP_FUSED_CMD
Message-ID: <ZAFjINz3FPZnSaCx@T590>
References: <20230301140611.163055-1-ming.lei@redhat.com>
 <7c787a9f-3cd9-cc76-8194-d861b5674334@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c787a9f-3cd9-cc76-8194-d861b5674334@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 03, 2023 at 10:52:00AM +0800, Ziyang Zhang wrote:
> Hi Ming,
> 
> I tried this patchset but there are some conflicts while applying.
> Could please tell me the base branch? I have tried both io_uring
> and block.

The patchset is against the following commit:

489fa31ea873 (master) Merge branch 'work.misc' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs

I guess there might be new io_uring/block commits merged recently.

I will send V2 out after 6.3-rc1 or -rc2 is released. 


Thanks,
Ming

