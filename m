Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57866596008
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 18:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiHPQVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 12:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiHPQVU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 12:21:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF21E1;
        Tue, 16 Aug 2022 09:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A469611D2;
        Tue, 16 Aug 2022 16:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7362DC433C1;
        Tue, 16 Aug 2022 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660666878;
        bh=G+oVel7Xivzjl7CyjzEJ6yCLiGZenrIQumLQqtDDsCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xggpu1DOYkCadzgc7xEfPrIG3CFadraRadRMkoQPKijONoOXyyM5ND20mOHIb2z57
         xA15/tG6mw1J6qX9cB6B9EHvuI6hACpJsJBnvm9eOgw/lt1PgKKQa/EXu1bqb1c5ai
         VLotg5R5xJT9WG5iY8oBpoh4A1dkwrAJygenH3AU=
Date:   Tue, 16 Aug 2022 18:21:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiacheng Xu <578001344xu@gmail.com>
Cc:     linux-kernel@vger.kernel.org, axboe@kernel.dk,
        asml.silence@gmail.co, io-uring@vger.kernel.org,
        security@kernel.org
Subject: Re: KASAN: null-ptr-deref Write in io_file_get_normal
Message-ID: <YvvD+wB64nBSpM3M@kroah.com>
References: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 17, 2022 at 12:10:09AM +0800, Jiacheng Xu wrote:
> Hello,
> 
> When using modified Syzkaller to fuzz the Linux kernel-5.15.58, the
> following crash was triggered.

As you sent this to public lists, there's no need to also cc:
security@k.o as there's nothing we can do about this.

Also, random syzbot submissions are best sent with a fix for them,
otherwise it might be a while before they will be looked at.

good luck!

greg k-h
