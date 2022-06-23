Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6AF557DF2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 16:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiFWOgG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 10:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiFWOgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 10:36:05 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99335DE8
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:36:04 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h20so7776771ilj.13
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 07:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=o6bfNyO+grfwYI8O6VBH29oTJ9fP+eODXsYPxnBOBlQ=;
        b=hFZ+icGMHcH4Cct3lgNL2bZku0EJFdxa6P6pHPn4Qm1worhwl436O6qGWpn1fBm9/L
         8g4tCT9UE3qpT5fhawKLsxrXtVMWduvVAeV2JxJng9+F84VUxPkdQIYgShV6BYmlao7K
         o8NhuQZF4WmeW8NkFjlboE20LdjWHo3rC8gdrUF8K5HyQD1honPRxh/CO8m3w4OdkV/B
         zeExIX+phL4vswc4ZeGzFhCaTcsdmIJawOCEfErblPq3x/v+q1D/tTJB+SHyO7t7POtf
         nY2rx7MUHz9NFsChsTeQ92UUDDDqbKH55QC5j6eOJVP0vDFBjOn900FKZyT9uXXCemP6
         IJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o6bfNyO+grfwYI8O6VBH29oTJ9fP+eODXsYPxnBOBlQ=;
        b=uxTY6rvfchctwWAx3KZUMVu4AtAkQvbCnGR3Ca9K9vTqqUFFArF2zs6SI1XW+1sw2M
         15SWoMlbBXb7YHQyMyWyV0I7rGXti2Ra19k2lolmEc81sldJOw1Egr7hF3P/U9yAdf2S
         8uCcquqwuWdGY3nwf+2P0K8opnBdGDZxPmkbP/o9yKxSAtXFTddm3UlDS/4/VNIlhxzk
         rVYd6t2nMleLY6iIkFby3drAboUzo8nSpIVlS9XoQzycTmHdtNt+N1xFY9qQm6isz6OE
         Nk/j6iYOMXMby8LfS6P9LWRKMbxEuOuaSgpPf160uhtS+CzO32z3CaBGTqylxz/xB6AL
         K3Fw==
X-Gm-Message-State: AJIora9qDagI/V3Jk2SXW605swNmpRc3e9Saowz/9RxV7PlP9BnIqi2g
        pkb9+Xms844/iSpvL5iUUWO23sSu2tdSVA==
X-Google-Smtp-Source: AGRyM1tob/vZqqlNTMvhEe0imVueYmQAJ+8jt2In8n0cFDJccPZvoiF+edGfToXZ2jsnBk+IjRQu+w==
X-Received: by 2002:a05:6e02:188c:b0:2d1:b91e:69b6 with SMTP id o12-20020a056e02188c00b002d1b91e69b6mr5428288ilu.118.1655994964138;
        Thu, 23 Jun 2022 07:36:04 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f22-20020a02a116000000b00339e6168237sm1268128jag.34.2022.06.23.07.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 07:36:03 -0700 (PDT)
Message-ID: <69518654-e762-cc1e-1262-a78433ee8e7b@kernel.dk>
Date:   Thu, 23 Jun 2022 08:36:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19] io_uring: move io_uring_get_opcode out of TP_printk
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
References: <20220623083743.2648321-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220623083743.2648321-1-dylany@fb.com>
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

On 6/23/22 2:37 AM, Dylan Yudaken wrote:
> @@ -390,6 +402,8 @@ TRACE_EVENT(io_uring_submit_sqe,
>  		__field(  u32,			flags		)
>  		__field(  bool,			force_nonblock	)
>  		__field(  bool,			sq_thread	)
> +
> +		__string( op_str, io_uring_get_opcode(opcode) )
>  	),
>  
>  	TP_fast_assign(
> @@ -399,12 +413,13 @@ TRACE_EVENT(io_uring_submit_sqe,
>  		__entry->opcode		= opcode;
>  		__entry->flags		= flags;
>  		__entry->force_nonblock	= force_nonblock;
> -		__entry->sq_thread	= sq_thread;
> +
> +		__assign_str(op_str, io_uring_get_opcode(opcode));
>  	),
>  

Looks like a spurious removal here of the sq_thread assignment? I will
fix it up.

-- 
Jens Axboe

