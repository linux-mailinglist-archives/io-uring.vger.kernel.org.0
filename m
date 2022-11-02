Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6B616115
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 11:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKBKnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 06:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiKBKnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 06:43:08 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9FA658F
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 03:43:07 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h9so23941567wrt.0
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 03:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Q01A0hdPaAHLx/ofl5mPZghsUCeuquh+nRBu74DPtA=;
        b=b3DFOOtK4q2Ox5gwdoAIdVZSnX+h0q5DcnHLJUA8ZlwWKtj3kTIZvUb34QGyA2ybOh
         HCdPFTYW9zLi9Xz6aJtMu/EBijRUbLoDoUjBmm+WEmHMTNMUj66M5vKqpxUt1eQMf2h1
         Xxvp8fQLA5Nd+AggpZhE3X+tRcxhj5bBGu0slyzLKfw0zPXHO26ZVRgGS6oSBb14pYvn
         G8NATxKBfcrqh+awRZnh2ovHyHH6KFRYYRbcuNx8YiFvoCsB3meFc9fDhmlt8+zgIkFy
         /UJ547H4MMEP2WUsYUzY9XzJS6tyOHqeRdUEvwQ3somYPsAcRTZdrOlRrYulhctXlk8m
         KdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Q01A0hdPaAHLx/ofl5mPZghsUCeuquh+nRBu74DPtA=;
        b=qGhhHFzE7UT3TFPTS5GIu8uOVaiAqmwkepsJAbGnDzr+GDFFMAjuovZZE4OHAv741o
         Y4leyIs97Qmh15Yf9FZc31/G5io0pXDFlsUtPvqLw2uX3Ogpo1bDjHRVMzGbWWsJU91Z
         JnF8gPoJlgqpC0MPhVDGp2wvwdMBDts1dWCKX3955ksDpoUb2eiLrkNA0/4YmdIdFaO3
         vK+Z/qmZZNDRy8ABZ/qPvx0qLGxw9uNrRmv1p9RNdbVhq++pI/7GuItLBU3500gnfqIE
         jfUCJ/HOoNbZ5R7UVvzx6MPj3qyNJrslFsA9/evYM7uPGUK+4YZ/4aIytg5ppBHeoRZC
         Z4Ng==
X-Gm-Message-State: ACrzQf1nv0vD6u97iiQf9+t+WDiBBcEJ66LU5LdJcY2Ph42K/J63/0eb
        wJEJXhgGvZkrCu2Kejpwtd8MGrRmzcg=
X-Google-Smtp-Source: AMsMyM7/I7coyYw1bdy7+by3xmBOwP7eD/VaBps6xZZCwouAN4mkQAHQpwkhZtfXizKfVkAmO6tQog==
X-Received: by 2002:adf:f5c4:0:b0:236:c419:710f with SMTP id k4-20020adff5c4000000b00236c419710fmr11040759wrp.56.1667385785072;
        Wed, 02 Nov 2022 03:43:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2739])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c4f8600b003cf4d99fd2asm1855770wmq.6.2022.11.02.03.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 03:43:04 -0700 (PDT)
Message-ID: <06f60984-151c-61c2-895f-41197271858f@gmail.com>
Date:   Wed, 2 Nov 2022 10:42:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH for-6.1 1/1] selftests/net: don't tests batched TCP
 io_uring zc
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/22 00:11, Pavel Begunkov wrote:
> It doesn't make sense batch submitting io_uring requests to a single TCP
> socket without linking or some other kind of ordering. Moreover, it
> causes spurious -EINTR fails due to interaction with task_work. Disable
> it for now and keep queue depth=1.

Jens, let's pick it up unless you have objections


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   tools/testing/selftests/net/io_uring_zerocopy_tx.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> index 32aa6e9dacc2..9ac4456d48fc 100755
> --- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> +++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> @@ -29,7 +29,7 @@ if [[ "$#" -eq "0" ]]; then
>   	for IP in "${IPs[@]}"; do
>   		for mode in $(seq 1 3); do
>   			$0 "$IP" udp -m "$mode" -t 1 -n 32
> -			$0 "$IP" tcp -m "$mode" -t 1 -n 32
> +			$0 "$IP" tcp -m "$mode" -t 1 -n 1
>   		done
>   	done
>   

-- 
Pavel Begunkov
