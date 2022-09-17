Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857D85BB808
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 13:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIQL6k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Sep 2022 07:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIQL6j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Sep 2022 07:58:39 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E0739B9C
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 04:58:38 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bh13so22735841pgb.4
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 04:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date;
        bh=KAS+AKXyVeVnFomdwQhIfYzf0KEgNCFfbGE6Db+U2iE=;
        b=8FGCtEAE/zXO6Q2W34PwyzX/Zspqmg4r87Ip6tVl9jNjDAI+0B0gtdIanaOilw9/Tm
         3WCnC9ZERxOSgD6cvIIHauWjToQ7g5tYO0kmdxuBzqOC8PTlfl/SgpgRP5FDagTOdz2d
         beZ0R0fE68fv9GWvubOCC6ceoxWG2k0UIPdzgsZoTLwwl6k/ev/wQRu47qN71sx11hTJ
         JXNdD//llcwnEw2Udzaz0D4J4W7RV/XM+KKbcsNwhuZQQbgDSIL6SmVZVwGuoKgpeQuv
         4eHoKIwiTuCVleXNLoq1FIjYkPjG61JBQsuDrU/mPlfTCklkdFSg02/EA/bFb1plMB7G
         sm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KAS+AKXyVeVnFomdwQhIfYzf0KEgNCFfbGE6Db+U2iE=;
        b=YeJcbd7foXWeR+sSb6pX2D9UNlSa3mhlx2/P8tdHG7DtnrZj4ei7Auwlq4TVSx6GDZ
         xkE5A1vn3H7sFRIWYd07qiydaTDB6G4BmrNZARzhMTAyNdfptW+fcmiZ7kZsslIKsn1K
         g2aMcZp+JjXnJBrx/feZ0qgcNzNyypgcjdP2o+duIX5tALGAllqUNilsbvoxGOJPqIuJ
         iDgpgNyQlkIG51oV+UXM2r2aCQsZ4w5vF0uR2Jf/LIeSGZn5Ll+CIjdRniGIko131ID3
         4c6+wZBaqKNAGsJLZhbiX/UviVY3rkYiefj6Ooky19UzPapZz3py8gR1KEsywVPkGS2S
         txZw==
X-Gm-Message-State: ACrzQf3JaPrWvG8L8v42md3RPJkomIH8MfBNTJyMQrJEp8T98xtnxygO
        DFzlQ5xJjV7RKllP3X0Q/Ug5xA==
X-Google-Smtp-Source: AMsMyM63RiYxANHDJDS91PkDfCpI7jfTlmR3Xzc0JXrb6LzzgpLo5DBA8eqFRSMxRylvWVtK/ZP4/w==
X-Received: by 2002:a63:f917:0:b0:439:1c07:d1da with SMTP id h23-20020a63f917000000b004391c07d1damr8462322pgi.13.1663415917589;
        Sat, 17 Sep 2022 04:58:37 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902f68600b00176b3d7db49sm16904715plg.0.2022.09.17.04.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 04:58:36 -0700 (PDT)
Message-ID: <b8656d4e-112e-1292-5d2f-52492e979c1d@kernel.dk>
Date:   Sat, 17 Sep 2022 05:58:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/1] io_uring/net: fix zc fixed buf lifetime
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
 <7099cb6d-4cfc-8860-0206-0844c4768a0f@samba.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7099cb6d-4cfc-8860-0206-0844c4768a0f@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/17/22 4:27 AM, Stefan Metzmacher wrote:
> Am 17.09.22 um 00:22 schrieb Pavel Begunkov:
>> Notifications usually outlive requests, so we need to pin buffers with
>> it by assigning a rsrc to it instead of the request.
>>
>> Fixed: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Looks good to me :-)

Can I turn that into an acked-by or reviewed-by?

-- 
Jens Axboe


