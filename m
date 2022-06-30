Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6CA561B05
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 15:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiF3NJR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 09:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiF3NJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 09:09:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C82018E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:09:14 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so2963798pjl.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=S6HHFRjkNbq1aBwXsluIrZKAK98lt7S+7ZHvnU55ZaA=;
        b=Xx9MwqQCFTq8YIwT83nRV5uDCVH+mTnDE6QJj4U4UBzg4qiVSrd+p4fGyjFkM52m1V
         CwENOOWo/7ihIKUHS6N/27FbBDRaFoVrmIyICWoumJRuZ3gE5s97Gntig13ZmQnkpGAJ
         8yJEEhwx2YQMdPWxAk0qefijMVjYSGKJuTUhYtTuVqg78ST1VExh1kzkvxGb2nPuVO9N
         q65AOnESQtt4BBcCAv6h49uTCKiJ4uFxQBXpnYM3p/LB5nrmC0D83nlTlRA02B3fxfsM
         eLcP0H3nfrZOeh/q3wbXbf0P86ZzzsWgYrPgvgIT7wQ9E26B4ahIP4IMqmmCkv60ORKD
         q+pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S6HHFRjkNbq1aBwXsluIrZKAK98lt7S+7ZHvnU55ZaA=;
        b=nI57dybJthkCfi93sZh/uECSTnj5Z0/xgSm16jAEnNGjpM4EXMVbEdyTZLAkjKrxS0
         wpHZT60KfXaL0nS4WQiRGSTSAjETSpfckicJ1jKW7WgtZ7PhzGDoUAkXnd36VmasrqkB
         EWp8pq6Ti6MhKs7/7OkdI2WwbSIrHdj5z7Wpg9hkXrRKk6QvS3gOYTy+Q7vd2zA54DVl
         9rmxT0vczTBihv/4tYsgeiKoar2iPSv6FGkxyBA3ab4YbE53RNRAN76N+VWRhRGMZu/s
         y2M1uYJfZ2g9deW98y3MpNL8OKg1oNRBcjROiZ5TIHRzx1bp2zBJaGAzQ/bHRorutcld
         l88Q==
X-Gm-Message-State: AJIora9fSwMOSu6j1jz1uiAw0fGchWpHgQ9MSO2Nj2ghAMwXXo4woKhH
        D/v9BF5LV0Ma/GKuRrYweI07QA==
X-Google-Smtp-Source: AGRyM1urQZMA2XLWVEWP1pMwDfxPI5a3gFRBHRiWdPtzEpyxR7D4Z0R1LicZn2JtZNx0lm+B7KPTcw==
X-Received: by 2002:a17:902:eb86:b0:16a:7401:7ac1 with SMTP id q6-20020a170902eb8600b0016a74017ac1mr16047544plg.101.1656594554161;
        Thu, 30 Jun 2022 06:09:14 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a6546c4000000b0040c9df2b060sm13451239pgr.30.2022.06.30.06.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 06:09:13 -0700 (PDT)
Message-ID: <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
Date:   Thu, 30 Jun 2022 07:09:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/3] test range file alloc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
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

On 6/30/22 3:13 AM, Pavel Begunkov wrote:
> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>  		return ret;
>  	}
>  
> +	ret = test_file_alloc_ranges();
> +	if (ret) {
> +		printf("test_partial_register_fail failed\n");
> +		return ret;
> +	}

If you're returning this directly, test_file_alloc_ranges() should use
the proper T_EXIT_foo return codes.

-- 
Jens Axboe

