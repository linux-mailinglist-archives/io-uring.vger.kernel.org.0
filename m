Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB9E7ADC6C
	for <lists+io-uring@lfdr.de>; Mon, 25 Sep 2023 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjIYPz1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Sep 2023 11:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjIYPz0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Sep 2023 11:55:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E119EC0;
        Mon, 25 Sep 2023 08:55:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 945F221220;
        Mon, 25 Sep 2023 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695657317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQMwDUeM2kKzJR4gEOjeLwCc83YXuYp+7QJGjBOfT3Y=;
        b=O0m7yEJRz0/GD6R3yjOrPTDlnBWlvIaDbBOH6ba/GMp+QOm9wwc7U/rOcigMD6pY/K1sHj
        5fvyFgluFFUDEQuIZblb0U2pXGriueR56woCZ1k87bvpHcbOziJuzLVmMWjGQQ9Z4OBjpF
        Zc6AwevUibXTAgu5dbszIYdQhH04LtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695657317;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQMwDUeM2kKzJR4gEOjeLwCc83YXuYp+7QJGjBOfT3Y=;
        b=8Mly58FPrFDCvgowtHljhGI71t4GcDtVVfhsukN1QBJnHIB0PdKW6DlAhaiK4wdLfIQ1Dk
        HCInleAP7gQQI5DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B1971358F;
        Mon, 25 Sep 2023 15:55:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N8NIEGWtEWWXZQAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 25 Sep 2023 15:55:17 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH V4 2/2] io_uring: cancelable uring_cmd
In-Reply-To: <20230923025006.2830689-3-ming.lei@redhat.com> (Ming Lei's
        message of "Sat, 23 Sep 2023 10:50:03 +0800")
References: <20230923025006.2830689-1-ming.lei@redhat.com>
        <20230923025006.2830689-3-ming.lei@redhat.com>
Date:   Mon, 25 Sep 2023 11:55:16 -0400
Message-ID: <87zg1a5jtn.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> uring_cmd may never complete, such as ublk, in which uring cmd isn't
> completed until one new block request is coming from ublk block device.
>
> Add cancelable uring_cmd to provide mechanism to driver for cancelling
> pending commands in its own way.
>
> Add API of io_uring_cmd_mark_cancelable() for driver to mark one command as
> cancelable, then io_uring will cancel this command in
> io_uring_cancel_generic(). ->uring_cmd() callback is reused for canceling
> command in driver's way, then driver gets notified with the cancelling
> from io_uring.
>
> Add API of io_uring_cmd_get_task() to help driver cancel handler
> deal with the canceling.

I think using ->uring_cmd() with IO_URING_F_CANCEL looks much
nicer. thanks for that.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>


-- 
Gabriel Krisman Bertazi
