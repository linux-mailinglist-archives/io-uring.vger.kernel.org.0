Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7A5047D3
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 15:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiDQNCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 09:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiDQNCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 09:02:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7F93389D
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:00:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k14so14373587pga.0
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=A9ep+0t0SHzVhCOCa80T6iei0KdMaD8rs0Zp9a1Q1T8=;
        b=pZDwoYQ5g5EO86JMInCFLqc0yHB6gwuE0mZ3RFH9uNqnJc6fFHPVA2YAMSwmUI0qWh
         A18btEwiW4+DjUtGNevp8CB5FQSP3rbr2v4HW274fiOJJMqd4Vup0DG5nv4hKNdQOaTd
         GGzai5JtSk4ClV1jT7DkpkUZdrYttULJqdH7oo18SVGHKP3DIJifHRaCFBqdoWJXMXV7
         wAzp3X8WI8lYWVG84GMk/2Jyy+REewqRGJeEe16Fs33ntv57fRnBwrxoLmfki1/SC17G
         KfXo+hmNxFcWYXpIyKb1Nmdz22jFtRsukaVv+67zdtbmIakz6UtI4lIhqOUJw8tLydpd
         y/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A9ep+0t0SHzVhCOCa80T6iei0KdMaD8rs0Zp9a1Q1T8=;
        b=d656g3sVep97UbZErwVEWd0+br+3XzUNWCvpKZZ7KnLpKE5ZGAUx/aNHs2mkp6wKYo
         aLyklmaHWyifMBAcMW3JwJBQ6MnKXWMnfPIfJN/WRmtzQQsRyxUkAAq8jesd+4XigWAP
         pbmeQ7cu9hKwhgGn5jGHI5p/jZfcG7YqHRHa9b2HSoiheXe762jSRsMbO6i+sAEHu1PA
         syUCzuBL+I0gVkhaJRGXCOZcyVoDkl7bqnJxKuWUSFhs/1AlP8zrdjRhg5fk2MB8Qu7a
         KXiGs6hl5uoegfkxi9T6KsGIee5DHgfpA4X7J55AyizooJ/ojnTz/vLTBm3uIxsLhBPz
         Eh1w==
X-Gm-Message-State: AOAM533iwMqH619oYtw20mO4ZH3okuSvt0wo4yBJj42oI4irL/X7e688
        1VuGCCUNN+8pRjPcljo/6Ke7R10sS0K7wZNK
X-Google-Smtp-Source: ABdhPJyaD5cs1Velv3qORPtVBZTfae0CsH66bsPTyA1dV9SAx2liHJbLq9jFGS2XZSRn0FDe9inPdA==
X-Received: by 2002:a65:5acd:0:b0:399:24bc:bbfd with SMTP id d13-20020a655acd000000b0039924bcbbfdmr6328683pgt.323.1650200414140;
        Sun, 17 Apr 2022 06:00:14 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 96-20020a17090a09e900b001cb62ee05besm13638297pjo.55.2022.04.17.06.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 06:00:13 -0700 (PDT)
Message-ID: <952f73a9-0a2d-bd4f-0489-b17c80a931ef@kernel.dk>
Date:   Sun, 17 Apr 2022 07:00:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing 3/3] tests: add more file registration tests
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1650186365.git.asml.silence@gmail.com>
 <d50933f8313050ee43353a1f0f368df9f9ea00c0.1650186365.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d50933f8313050ee43353a1f0f368df9f9ea00c0.1650186365.git.asml.silence@gmail.com>
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

On 4/17/22 3:09 AM, Pavel Begunkov wrote:
> diff --git a/test/file-register.c b/test/file-register.c
> index bd15408..ee2fdcd 100644
> --- a/test/file-register.c
> +++ b/test/file-register.c
> @@ -745,7 +745,90 @@ static int test_fixed_removal_ordering(void)
>  	return 0;
>  }
>  
> +/* mix files requiring SCM-accounting and not in a single register */
> +static int test_mixed_af_unix(void)
> +{
> +	struct io_uring ring;
> +	int i, ret, fds[2];
> +	int reg_fds[32];
> +	int sp[2];
> +
> +	ret = io_uring_queue_init(8, &ring, 0);
> +	if (ret < 0) {
> +		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
> +		return ret;
> +	}
> +	if (pipe(fds)) {
> +		perror("pipe");
> +		return -1;
> +	}
> +	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
> +		perror("Failed to create Unix-domain socket pair\n");
> +		return 1;
> +	}
> +
> +	for (i = 0; i < 16; i++) {
> +		reg_fds[i * 2] = fds[0];
> +		reg_fds[i * 2 + 1] = sp[0];
> +	}
>  
> +	ret = io_uring_register_files(&ring, reg_fds, 32);
> +	if (!ret) {
> +		fprintf(stderr, "file_register: %d\n", ret);
> +		return ret;
> +	}

This check looks wrong.

-- 
Jens Axboe

