Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E186F0FE3
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 03:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344285AbjD1BJF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 21:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjD1BJE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 21:09:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04997268E
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 18:09:03 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a66e6160easo12564615ad.1
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 18:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682644142; x=1685236142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tyGALp/u2CSO1u+d88PyfpvACmbFLcynyU8qPGUMzUU=;
        b=lU/7idJ521ibZpQiH6z16ClfGovDOGIcTcXZZs4mUK80BkgjHm47/mPqb7kcHHDNGC
         8SIKYD8Bq1eAtQrShbt2++dQJdpDjCrMOvmXmJyb+TAcEJdCh41pYdq1EOa5oq/fo4cd
         GLVkJ226KXNR79GrpLZ8bEvgsADmy4Cuuf5p/OsDivde+bMBTg8JZbU9Xfp/JCq+cZM3
         lchkqdOXEeS+QOa+BXzMeEnw/YtL/amwpxoPMi3bVobfVVb9uIrxcPuM/u8hXn9yR/eK
         2zqWJuMMKks8M0KPSkgVQ84tsWp7M2xmX2Ch958DeNSF33anchGCizc4AH9j5UG1nxra
         iiog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682644142; x=1685236142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tyGALp/u2CSO1u+d88PyfpvACmbFLcynyU8qPGUMzUU=;
        b=TbNkSRpEl6BHWcQfJ4feuTfhxkCuw74YEmzeqYCh489GdUiqq7z5od7HQ40ya1XFeM
         mgig89F9GMGZ0cK0fs76usN8n6Dy0KIvXtsS7lmzq95lSIkhaiN9Rl+J4uwbnwtoktOL
         U6nLtYAudohTwISprVBjj+ey+ucRLDsGAnsQ8iWkjjU+IRW1rwsHR5FMVlnYq9E8IL+Q
         UhAbNsUoJ6Q7Jvx+iBWDAn4M/pZRZTCyJnqpBLoZufo5zqB1LJUSJGsX94x/UIMuvspD
         P2sHGZ15sQFjncbNKSY84eY8BDrLUMHqKIVbxthR88oZDXi7rkYdtcykXLg9qWO92g80
         wf0A==
X-Gm-Message-State: AC+VfDzmuKaGaXIApA5d3eAbkKmiECCMl3rJ5iDozxoqsdNeqix9dNGl
        sqqo/1Jz0UmfLTCAIqumWZ9qdwbH6Q1kWid8cLQ=
X-Google-Smtp-Source: ACHHUZ4NBv2PibcpkVnJp6h7NCrgVlK6QGaZzYFRwDjGhVU9TjCHOJlYfLfqTcujFYxeVZ6RcI9ntQ==
X-Received: by 2002:a17:902:ce89:b0:1a4:f4e6:b68 with SMTP id f9-20020a170902ce8900b001a4f4e60b68mr4191616plg.3.1682644142448;
        Thu, 27 Apr 2023 18:09:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902768800b001a80ad9c599sm12123301pll.294.2023.04.27.18.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 18:09:01 -0700 (PDT)
Message-ID: <80e208ba-be78-f3d0-9fa9-f3e9ec214e4f@kernel.dk>
Date:   Thu, 27 Apr 2023 19:09:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
 <qvqw354lb5bl.fsf@devbig1114.prn1.facebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <qvqw354lb5bl.fsf@devbig1114.prn1.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/23 10:27?AM, Stefan Roesch wrote:
>>> +	if (timespec64_compare(ts, &pollto) > 0) {
>>> +		*ts = timespec64_sub(*ts, pollto);
>>> +		*new_poll_to = poll_to;
>>> +	} else {
>>> +		u64 to = timespec64_to_ns(ts);
>>> +
>>> +		do_div(to, 1000);
>>
>> Is this going to complain on 32-bit?
>>
> 
> My understanding is this should work on 32-bit.

Yeah seems fine, I ended up double checking it too.

-- 
Jens Axboe

