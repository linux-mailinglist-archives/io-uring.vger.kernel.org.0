Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837F7708D58
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 03:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjESBaU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 May 2023 21:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESBaT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 May 2023 21:30:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5181E3
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:30:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1ab0595fc69so3334835ad.0
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459818; x=1687051818;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrnboP0peGSA76yrr8ewIv/4vnkovOg0aJgcnf8r9sk=;
        b=njwvMIr9I8Qm0aPbmTsk5j4qCffOf2Y11PaU0cn2Odh3Z31zfI2Xm7lzghSzHYffwW
         l8X29BNWYodJWSw8g2ALynrSHpcwgpiCc7gdqKRtfw21qC2q65locwbQ+dt+00Xfmwt9
         Bd0ik7KMZjb0GI6oTsot9ydzS6XnhqjVxnX/zeUqhDSKA+4Aoh5vGGGOIhM81QE6uVNT
         FO7U9r4PtKUd6bgcXRV/C3negfv4NnSlbCPtkX8x20UgbuMBLc2Xlh/UAIoGzNwTNC8z
         MlrJVosezXM7DIU8seaRfu3EbPav4I0W0H0EWUXDpd0LE7DEwfR78cFcg7h7kHMwadXu
         2c6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459818; x=1687051818;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrnboP0peGSA76yrr8ewIv/4vnkovOg0aJgcnf8r9sk=;
        b=PmYHSTsYjxUT+vKXPnw/16yyf5n7mkTERQhe06cBfF4jQSFKwRtyGt2DkRBt/1YxBN
         swcnpBrn8Tt6cJqHOeSx8T2mCCuuqymbwo0guaEC3u+sTOEtLG37HpOQQEmfRcq7G/Gc
         CATrQE7vxIIDMTlHHxWKBE31dEp77ae9glRmdVf/PU/AP7d8ltzGqQCMYcMnlLi25p4l
         P7VAWr9sh5O4OalP66smpuWktmABWz1L95wik2noYNFf43nJbm4uX4ylQcAnhfB3ZjT7
         fWVksAvW2K57mmPYqG5gQcPEsEiTD3pwefun2XO79+2oklOnnPKDCuPFB6sAu1BcLelK
         s7ag==
X-Gm-Message-State: AC+VfDwy55NEbe6D7jqRkHXpAW29uO/yQYWGh6ruPirC6aTJFmj0hVDg
        X5ACF+w3QkyVG4I9tSt3kcpMEA==
X-Google-Smtp-Source: ACHHUZ6tEtAuZJ4teFs/1/px7ORv43Oay58rwmwjdUFadzYwCH3fZnbJDOItIlz+X1Nqe5GumBO4Jw==
X-Received: by 2002:a17:902:e752:b0:1a4:f4e6:b68 with SMTP id p18-20020a170902e75200b001a4f4e60b68mr1118492plf.3.1684459818399;
        Thu, 18 May 2023 18:30:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902eac200b001a661000398sm2109687pld.103.2023.05.18.18.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:30:17 -0700 (PDT)
Message-ID: <57738de1-5a11-053f-c24c-e886a51367fc@kernel.dk>
Date:   Thu, 18 May 2023 19:30:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 6/7] io_uring: add register/unregister napi function
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
        olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-7-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-7-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/23 3:17?PM, Stefan Roesch wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f06175b36b41..66e4591fbe2b 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -4405,6 +4405,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>  			break;
>  		ret = io_register_file_alloc_range(ctx, arg);
>  		break;
> +	case IORING_REGISTER_NAPI:
> +		ret = -EINVAL;
> +		if (!arg)
> +			break;
> +		ret = io_register_napi(ctx, arg);
> +		break;
> +	case IORING_UNREGISTER_NAPI:
> +		ret = io_unregister_napi(ctx, arg);
> +		break;
>  	default:
>  		ret = -EINVAL;

To match most of the others here in terms of behavior, I think this
should be:

	case IORING_REGISTER_NAPI:
		ret = -EINVAL;
		if (!arg || nr_args != 1)
			break;
		ret = io_register_napi(ctx, arg);
		break;
	case IORING_UNREGISTER_NAPI:
		ret = -EINVAL;
		if (nr_args != 1)
			break;
		ret = io_unregister_napi(ctx, arg);
		break;

Apart from that, looks good.

-- 
Jens Axboe

