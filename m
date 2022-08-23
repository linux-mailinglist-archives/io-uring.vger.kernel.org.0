Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CB659D185
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 08:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbiHWGvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 02:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbiHWGvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 02:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8348E32BA9;
        Mon, 22 Aug 2022 23:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 225456135D;
        Tue, 23 Aug 2022 06:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13661C433D6;
        Tue, 23 Aug 2022 06:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237465;
        bh=RohjBzJApuT97cn78xLjdi9BLBf29NTQ68MN5gRMoPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VvlPfkBnDIO74MOkmopSXdIwTc3TJMgFx/nsUAYuwcrD6DwdYYSo1LtAnqBOuONWW
         7+sy/aFW5brDM2CdRHMFu4/MF0/bezZ1lvIw+Ck4onLxFtAaoPySCxdNjIFSTKEJVw
         9I4M9Q/B8gWVE4LfV+K9CKk++G8QqBIM37TzkaHY=
Date:   Tue, 23 Aug 2022 08:51:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 3/3] /dev/null: add IORING_OP_URING_CMD support
Message-ID: <YwR41qQs07dYVnqD@kroah.com>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120327984.369593.8371751426301540450.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166120327984.369593.8371751426301540450.stgit@olly>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 05:21:19PM -0400, Paul Moore wrote:
> This patch adds support for the io_uring command pass through, aka
> IORING_OP_URING_CMD, to the /dev/null driver.  As with all of the
> /dev/null functionality, the implementation is just a simple sink
> where commands go to die, but it should be useful for developers who
> need a simple IORING_OP_URING_CMD test device that doesn't require
> any special hardware.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  drivers/char/mem.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 84ca98ed1dad..32a932a065a6 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -480,6 +480,11 @@ static ssize_t splice_write_null(struct pipe_inode_info *pipe, struct file *out,
>  	return splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_null);
>  }
>  
> +static int uring_cmd_null(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> +{
> +	return 0;

If a callback just returns 0, that implies it is not needed at all and
can be removed and then you are back at the original file before your
commit :)

thanks,

greg k-h
