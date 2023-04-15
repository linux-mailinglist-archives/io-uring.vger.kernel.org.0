Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1206C6E339A
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 22:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjDOUh2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 16:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjDOUhW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 16:37:22 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA6049D3
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:37:21 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3e69924e0bdso12983591cf.1
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681591041; x=1684183041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cTmcDCI1g6ly0jkiEWSmK22I4N076G9Rl7p/BC3CWSA=;
        b=2oFjM5CKkE9Y1NBcJWToRDPvRfkXWcTBPHQtvq0RZ+hI9FLAfCi0S6LLA4urYtiXok
         vnLIKGW6Yw/uC3xTKgN+wMebLjOGGc9gxnh+JQXcguqPhvR1eXwCmlFKmwKnS9O5V+EG
         rFBcXcaHcM84qkV+5k/whY0SFgQQCSuBT3IFCxyYSdr1oqUjTUimChWP/FLEmYa0deU1
         KOF6JmiTHy8FcXvR15mJkC4p/jvlsal6ccE+zMjEItMYH8PA8a/Tg4Z1LGznH7z1sv/n
         zRWO84b4pl2sblkDsZ+q5Jl8dchdVXV1kQN0aVyDeZ2tqV1tlqzdbfQPEjRLxs4twlBW
         0GbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681591041; x=1684183041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTmcDCI1g6ly0jkiEWSmK22I4N076G9Rl7p/BC3CWSA=;
        b=clFZmn9t4bmr9u2SH2iRIS2vqDbuu7Xanl36ahiQRv6N4OTe/AF5MMOMFiD71LrQTu
         m3CBQyqWXqZrpwQ1zEPLaIEu0ktvgq/7K4jWSog80xZFFoh5obb5cAanGSQJ1nvdlIDf
         SurlsqJjSfeOX46ZewxIlHfgt/f5eikfHSONu7wHf376P0E+83vlzyupS/IDImaLKzdK
         AHuXpxl5g2oEbyJpwonThXfomXXiA5dOJRVRqUsPLbI6uH0g9oEBH/XE59X0EVuvB1By
         KbSpnqUMmpsymo/mhGmH4kp0LbaZ/Y/Blzzx9JS7fK75mbS31cRJxbamwKDom9kPiq+V
         FaTg==
X-Gm-Message-State: AAQBX9efIn842kiRPJSV3JNbPQAv8l2bzS8k+THEkS2ZHdQ4VP+0sEfi
        +zFGKo+7IlxH6HsrQ6pLF8z/ww==
X-Google-Smtp-Source: AKy350ar8Z9BcrJu37vKXdxyl2+fd0dxHlh+GaKaawi25UX4NgYUS977rDlvYYZKGLlMBjhb0S4oWw==
X-Received: by 2002:a05:622a:1aaa:b0:3ee:5637:29cc with SMTP id s42-20020a05622a1aaa00b003ee563729ccmr1689861qtc.0.1681591040667;
        Sat, 15 Apr 2023 13:37:20 -0700 (PDT)
Received: from [172.19.131.144] ([216.250.210.6])
        by smtp.gmail.com with ESMTPSA id h2-20020a05620a21c200b00743592b4745sm2084371qka.109.2023.04.15.13.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 13:37:20 -0700 (PDT)
Message-ID: <4b384eab-08cd-c777-8560-ff50aeba906b@kernel.dk>
Date:   Sat, 15 Apr 2023 14:37:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH for-next 1/1] io_uring/notif: add constant for ubuf_info
 flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2906468a8216414414e8e5c06dc06b474dff517a.1681563798.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2906468a8216414414e8e5c06dc06b474dff517a.1681563798.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/23 7:20 AM, Pavel Begunkov wrote:
> Add a constant IO_NOTIF_UBUF_FLAGS for struct ubuf_info flags that
> notifications use. That should minimise merge conflicts for planned
> changes touching both io_uring and net at the same time.

Applied, thanks.

-- 
Jens Axboe


