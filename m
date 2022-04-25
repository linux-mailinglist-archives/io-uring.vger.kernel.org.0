Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986F950E085
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiDYMlr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiDYMlo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 08:41:44 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48040B1AAC
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 05:38:39 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q8so3556456plx.3
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 05:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=h0N7Xw9ayMdjNwT+dSboLXsyap22Y+266R7Xi2cibFs=;
        b=61PV7TT9x9f2J91ymKhTAJROmDBdiSnye7cS97bFeFx0tnP5BXAq022YG7YU7EOkUS
         ATRWyhxtuN/PB98vOXniHDwoEbBcib7Yp8Rj7/khDwA+4lRccTZFoSA9QEAJvv6DJxtb
         uYePq8Sny77H+B1cV52bKymyPEeMg9JJpt7fKHTYaRk9XLwSbWTcL7Ezv4lC3W8mQr/r
         9odzAkJrVJAirgJF3feTFpPZkT20O8XtOAOfCPaOBjazzISiIUa95+t9nFMoiDy0bA4z
         xc5ooOezfu1vhDZ9xY1qdVQspfrRHVCrtgpj0oaKY4T3CtHT9ePntdk92jmyugnu39vo
         Zz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=h0N7Xw9ayMdjNwT+dSboLXsyap22Y+266R7Xi2cibFs=;
        b=boKdgAB1mtRbOQDAqfFvpmAwZSZqTkJBUV4BlzfCTxW/jcLkhS+X8uYORs8uzFRFy6
         h+p8MZcR+jnL5qKyWRMFlPszaGTkfiLv49FcfFtz+4REvv9MGX4FBGsjTSWICgUKDMzo
         PsIGTl9oQDPepVLM/abU8QBJeGguTPTjFNKpx6ILKQuzfRPvhFJlEofFdwTUNeDhth7o
         OYmcl7BFeK+vcl7tYgKkGt6PW5xWJSnLzjMcCLLhwqPV+3/REjCqVMcyRXvdX7k700OZ
         59JRIAdO10AdEEZHosrFbt35Bxz5y2/AokjKr9xZy4vbqjPeKTU792y3zPVAH7du9iZq
         wbBw==
X-Gm-Message-State: AOAM531WE6SclvAeVXurLqtZqC2OE7m20aWt8hOrP9x/bWsQgr6K8efv
        DVOdRNG0XVyghPNHRqjzuA2MCA==
X-Google-Smtp-Source: ABdhPJzblpd/s3fALv+p83Q+7D6atxbr9Isq/TnwnxkM0Yt41RJhTmNAu9I+aeXEkt9NqwqGBfV0tQ==
X-Received: by 2002:a17:902:e494:b0:15a:4b81:1c16 with SMTP id i20-20020a170902e49400b0015a4b811c16mr18158054ple.10.1650890318954;
        Mon, 25 Apr 2022 05:38:38 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 64-20020a17090a0fc600b001d5f22845bdsm14878023pjz.1.2022.04.25.05.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 05:38:38 -0700 (PDT)
Message-ID: <5e09c3ea-8d72-5984-8c9e-9eec14567393@kernel.dk>
Date:   Mon, 25 Apr 2022 06:38:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] io_uring: add io_uring_get_opcode
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Kernel-team@fb.com
References: <20220425093613.669493-1-dylany@fb.com>
 <20220425093613.669493-2-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220425093613.669493-2-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/22 3:36 AM, Dylan Yudaken wrote:
> In some debug scenarios it is useful to have the text representation of
> the opcode. Add this function in preparation.
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>  fs/io_uring.c            | 91 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/io_uring.h |  5 +++
>  2 files changed, 96 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e57d47a23682..326695f74b93 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1255,6 +1255,97 @@ static struct kmem_cache *req_cachep;
>  
>  static const struct file_operations io_uring_fops;
>  
> +const char *io_uring_get_opcode(u8 opcode)
> +{
> +	switch (opcode) {
> +	case IORING_OP_NOP:
> +		return "NOP";
> +	case IORING_OP_READV:
> +		return "READV";
> +	case IORING_OP_WRITEV:
> +		return "WRITEV";
> +	case IORING_OP_FSYNC:
> +		return "FSYNC";
> +	case IORING_OP_READ_FIXED:
> +		return "READ_FIXED";
> +	case IORING_OP_WRITE_FIXED:
> +		return "WRITE_FIXED";
> +	case IORING_OP_POLL_ADD:
> +		return "POLL_ADD";
> +	case IORING_OP_POLL_REMOVE:
> +		return "POLL_REMOVE";
> +	case IORING_OP_SYNC_FILE_RANGE:
> +		return "SYNC_FILE_RANGE";
> +	case IORING_OP_SENDMSG:
> +		return "SENDMSG";
> +	case IORING_OP_RECVMSG:
> +		return "RECVMSG";
> +	case IORING_OP_TIMEOUT:
> +		return "TIMEOUT";
> +	case IORING_OP_TIMEOUT_REMOVE:
> +		return "TIMEOUT_REMOVE";
> +	case IORING_OP_ACCEPT:
> +		return "ACCEPT";
> +	case IORING_OP_ASYNC_CANCEL:
> +		return "ASYNC_CANCEL";
> +	case IORING_OP_LINK_TIMEOUT:
> +		return "LINK_TIMEOUT";
> +	case IORING_OP_CONNECT:
> +		return "CONNECT";
> +	case IORING_OP_FALLOCATE:
> +		return "FALLOCATE";
> +	case IORING_OP_OPENAT:
> +		return "OPENAT";
> +	case IORING_OP_CLOSE:
> +		return "CLOSE";
> +	case IORING_OP_FILES_UPDATE:
> +		return "FILES_UPDATE";
> +	case IORING_OP_STATX:
> +		return "STATX";
> +	case IORING_OP_READ:
> +		return "READ";
> +	case IORING_OP_WRITE:
> +		return "WRITE";
> +	case IORING_OP_FADVISE:
> +		return "FADVISE";
> +	case IORING_OP_MADVISE:
> +		return "MADVISE";
> +	case IORING_OP_SEND:
> +		return "SEND";
> +	case IORING_OP_RECV:
> +		return "RECV";
> +	case IORING_OP_OPENAT2:
> +		return "OPENAT2";
> +	case IORING_OP_EPOLL_CTL:
> +		return "EPOLL_CTL";
> +	case IORING_OP_SPLICE:
> +		return "SPLICE";
> +	case IORING_OP_PROVIDE_BUFFERS:
> +		return "PROVIDE_BUFFERS";
> +	case IORING_OP_REMOVE_BUFFERS:
> +		return "REMOVE_BUFFERS";
> +	case IORING_OP_TEE:
> +		return "TEE";
> +	case IORING_OP_SHUTDOWN:
> +		return "SHUTDOWN";
> +	case IORING_OP_RENAMEAT:
> +		return "RENAMEAT";
> +	case IORING_OP_UNLINKAT:
> +		return "UNLINKAT";
> +	case IORING_OP_MKDIRAT:
> +		return "MKDIRAT";
> +	case IORING_OP_SYMLINKAT:
> +		return "SYMLINKAT";
> +	case IORING_OP_LINKAT:
> +		return "LINKAT";
> +	case IORING_OP_MSG_RING:
> +		return "MSG_RING";
> +	case IORING_OP_LAST:
> +		return "LAST";
> +	}
> +	return "UNKNOWN";
> +}

My only worry here is that it's another place to touch when adding an
opcode. I'm assuming the compiler doesn't warn if you're missing one
since it's not strongly typed?

In any case, the LAST one is just a sentinel, both that and beyond
should return eg INVALID.

-- 
Jens Axboe

