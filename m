Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F190F750F1B
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjGLQ64 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 12:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjGLQ6z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 12:58:55 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4BFCA
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:58:53 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-346434c7793so7057625ab.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 09:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689181132; x=1691773132;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gD3LxyYJLJuoNijLR3tj4YKNN2NQwtuRF/izLAKlQPo=;
        b=kgB6+MtKDDGmqYy9VI/6CisnIOHmbu4YQ5s7SrJ2lxiydOqCIyvdtqzhpGUNhFUOBC
         cd3/9tOc0r4y4Naz4Ls+ps8jrSabgzqBOJK/wpPRwGiXuG/ueqPGph56WrqP8IlseP41
         BxEeX1JlVeKWhaVeTNy4CZ5X4hm7fc8SC1JInD4IjVLI6q7J1RwpeWy96U0WHCe2nu1A
         QoPHh788NapRX05wtuCvr+iSl2HBX5TMQio3K9w6CBYhodY7eDWmnPqkt6clYswmL8jy
         nh1sVqKpLDuV/hZgrJZcE0EDjt2pvMq+4J731c9vhBXEzCO30HnNwl39PWA4TVmV6iYp
         8udA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689181132; x=1691773132;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gD3LxyYJLJuoNijLR3tj4YKNN2NQwtuRF/izLAKlQPo=;
        b=PY0qxTvRl45yfc0+a6Lvfh+oTBl8TK6c7OjDU9YkWup9F5sLtqBwXzAcH0wTVEW13M
         4rPAI8IAsdOyOCVupEC4B3+NQPX2L5AxMPWx1QNEL26X5xRLSbNGbD3KYIe1WnCK7z5u
         8KXZ5UporCN/a4zdX2ptM1teHDYp/LrzKBysjMSNa0tlTBQUdNrNZ1vBBnhmHh85OtIf
         /xF/u4KYy5YAzwksSdOfp1+3plNrie2XPpFUwYoScM2PV+EU3fLWvkkGxnYsDk9wOF/Q
         eGdC7W2ECboY8Cl2l4EuOdLzBJL1dtLkPEsa2cv67uPTsKmgdaEZyGr0S8sA878eLLfB
         DcQQ==
X-Gm-Message-State: ABy/qLaxFyDCNOkGI8LmMr+i+cLjqCt5LvxAbQ4SxqWhsww13uN/zpj3
        uh+HFlh8r3FTrDq/arE1zhbaMKxX9UYX9uJbVDI=
X-Google-Smtp-Source: APBJJlHCouEghFQjm5Slf03S3htf6T3iNRRjMudH5i65VKw/grYVNT61j77a6q//bCkkSoJY8dZRnw==
X-Received: by 2002:a6b:1489:0:b0:780:cde6:3e22 with SMTP id 131-20020a6b1489000000b00780cde63e22mr18321872iou.0.1689181132510;
        Wed, 12 Jul 2023 09:58:52 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n14-20020a056638120e00b0042b11990d29sm1302323jas.103.2023.07.12.09.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 09:58:51 -0700 (PDT)
Message-ID: <624160ca-ccea-0389-6e17-2dd2daf1451d@kernel.dk>
Date:   Wed, 12 Jul 2023 10:58:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCHSET v2 0/8] Add io_uring futex/futexv support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        andres@anarazel.de
References: <20230712162017.391843-1-axboe@kernel.dk>
In-Reply-To: <20230712162017.391843-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Neglected to mention, that I have run this through the ltp futex tests,
and there are no changes. All tests pass.

-- 
Jens Axboe

