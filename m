Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0F155E84D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347189AbiF1PM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiF1PM0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:12:26 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA1E2B241
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:12:25 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a10so13151118ioe.9
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zgi/7+6eFIGPqLxDNnNayXAaz/C0VCUdgOz60BwoFKs=;
        b=0r1VeEQo5BOUs0Y42+eaSNEbybS3y2cKZGt3LzIE9MLH4xZ/pOk29uczR2mRzckFIn
         rc5nrZcBH+dnh4TVbyQ212cs09osFIzsQmM7kSYnsm97i4d5JVf6L8SUk8IWVPWhF8At
         cXp+CKy41AvPwvrdRD8jafW7bvmWdn5t5Yh0gSxP83Ln11Me+tpUp1XjPXE2J5+aAQ6O
         ijPERjNTZ7ephOs3pQGJ/LjMVrsNZ2UMbSv/ifvdPzslYdSq9Sr5AlHk5PcHfNK26DBX
         I9s2BV8oa0H0u6yTyLerp/Ka0uT3rKqimNKG90S8I5Wlo1LS5RhynQeZUkYFp2F+waTX
         7zpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zgi/7+6eFIGPqLxDNnNayXAaz/C0VCUdgOz60BwoFKs=;
        b=jGef/GUNtEXEJNq0ztcs2iopH3kTIB0swCf7qZmBOj6J7Rwpc9i4MXzoqV/wfcu97k
         Xlz6197kKHW9pe+hALbhjqs9MwZqQNx4wYchdE52JlmhWiHFc6IIl3DG/H1pBmAnq4ro
         Htu/lMGSty6ancXzCtftcuQkoBJCgbku2jcjK+qf5M4KpReaFA1/QWcU++xm9dIjcvuo
         RDHeXuEtx1bmeAwDDpraPH6Arb41OYbD0QEtebjZHkoHyZNq47tTQFl2gz27wpvEelJh
         ZFcuji3ayY75qUItGBiLWzvIYeY2OGUV4zz5Qu9oGbYEMMbBOcFJoqvCjRRBpmD5sBOm
         fD0Q==
X-Gm-Message-State: AJIora+RaVVyqWa/8ImWtvsK/6VsrxiPyzLhQ0bwo8+5EjeX1D+N8UWX
        cM9zd2gk5qU5Sz6bGcwpVNhTwqC+wXfoKA==
X-Google-Smtp-Source: AGRyM1sVN+VpZN9Z56m7ywKdMJuC8hcC2TskLsnRvqym9GlzU3JPaYJkHd+rbii+2PEEHQ3OFDPW6g==
X-Received: by 2002:a05:6638:42c9:b0:33c:1243:282c with SMTP id bm9-20020a05663842c900b0033c1243282cmr9789767jab.290.1656429144868;
        Tue, 28 Jun 2022 08:12:24 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q18-20020a02cf12000000b0033c829dd5b8sm4116937jar.161.2022.06.28.08.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:12:24 -0700 (PDT)
Message-ID: <b666a619-1b4c-0c47-95b9-8db185b1ad05@kernel.dk>
Date:   Tue, 28 Jun 2022 09:12:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 2/8] io_uring: restore bgid in io_put_kbuf
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com, linux-kernel@vger.kernel.org
References: <20220628150228.1379645-1-dylany@fb.com>
 <20220628150228.1379645-3-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220628150228.1379645-3-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 9:02 AM, Dylan Yudaken wrote:
> Attempt to restore bgid. This is needed when recycling unused buffers as
> the next time around it will want the correct bgid.
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>  io_uring/kbuf.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index 3d48f1ab5439..c64f02ea1c30 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -96,16 +96,20 @@ static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
>  static inline unsigned int __io_put_kbuf_list(struct io_kiocb *req,
>  					      struct list_head *list)
>  {
> +	unsigned int ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
>  	if (req->flags & REQ_F_BUFFER_RING) {

Should have a newline here after the 'ret' variable declaration.

-- 
Jens Axboe

