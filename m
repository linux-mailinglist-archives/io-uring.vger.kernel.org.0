Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2560557A05
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 14:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiFWMJO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 08:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiFWMJN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 08:09:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB094DF46
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:09:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id l6so9821624plg.11
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 05:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=F//xj1I48rHIlAhMkoWwtxdKdV1eD7QY8B7HPLj5VR8=;
        b=VdYTiDVsDmkeqa4+O3JAoUFAMFwRVXfG3pPiudSBSa/Uabg/oLFPiVSyunZ8rtaVts
         otEbcXl/yF+fIMR18G5cIo7EsfCSoo624tyDYQ5SwowRPaid/h7+H2RilouB/fInTwEf
         v+VKePqVkWNnOovgkROA21e21GMcKDZAf2Df8BBsgCLNQwCYrO35XsXs6AdlkBvPNA9X
         oDWqA4nBlko2b4f7ZAzCi/vm8aprNLDY4t/cGXdrQvsf4zOgeCsXViCjtFE630ploApW
         mJPr2aJymjzFG78Tm922GbdljpXae0DcEkLKp3GGui/OCfRVPaqzt4ESNMBySWZMqFDx
         JcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F//xj1I48rHIlAhMkoWwtxdKdV1eD7QY8B7HPLj5VR8=;
        b=P9pZSXfEvWv9CltUwGC5GBZHEGyOJPeX815hk6xtO5uGjWZ9PxuasuyN8EP/Pboeop
         2de36kW6WbA2iIfaM+j6z0s0BeWhrhAmqC3gjaEpvS2LZamyVVltz7G1/k7KC2WUCBsx
         80LemsV1K6t2Giu9ZhCl3jlvjIUfGfc8Ycu00vSXORO4Fv7XrcWCFvxBZyrGi9saAtxE
         ZA7R9XxhQ5TnXwmrAU4yqpJubHn83SaGsWIJSKY07P6lBGLXAc9uMqjHlyjeABhQ6FX2
         DnufSZoSJDa4dzgXirCwQxhHbki5Qa9xsqJiBd5as8O+Z1l+PFRQWxhXA31VvHFOShk+
         avpQ==
X-Gm-Message-State: AJIora+0ANgbF1gjHtocvZoSfLLYstyRL3eXfdc46BPtRGiWda4uuUe3
        yjiuqQ5RryquxC5khKwhQiautpoY6IHpcA==
X-Google-Smtp-Source: AGRyM1td4PcbKtSkZuMePbjEteSWcI0q0M/LF8+7Wh/zClqjtZA7dCgjmz7dXJDO3mGjrG+dMywFjw==
X-Received: by 2002:a17:902:f689:b0:16a:4021:8848 with SMTP id l9-20020a170902f68900b0016a40218848mr11042059plg.23.1655986148148;
        Thu, 23 Jun 2022 05:09:08 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v5-20020a17090a088500b001e29ddf9f4fsm1750814pjc.3.2022.06.23.05.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:09:07 -0700 (PDT)
Message-ID: <814e42a9-82ce-b845-8b7e-d8cedefe9c39@kernel.dk>
Date:   Thu, 23 Jun 2022 06:09:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 5/6] io_uring: refactor poll arm error handling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655976119.git.asml.silence@gmail.com>
 <6dd4786bca9a3d1609f85865936349cac08ac8e0.1655976119.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6dd4786bca9a3d1609f85865936349cac08ac8e0.1655976119.git.asml.silence@gmail.com>
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

On 6/23/22 3:34 AM, Pavel Begunkov wrote:
> __io_arm_poll_handler() errors parsing is a horror, in case it failed it
> returns 0 and the caller is expected to look at ipt.error, which already
> led us to a number of problems before.
> 
> When it returns a valid mask, leave it as it's not, i.e. return 1 and
> store the mask in ipt.result_mask. In case of a failure that can be
> handled inline return an error code (negative value), and return 0 if
> __io_arm_poll_handler() took ownership of the request and will complete
> it.

Haven't looked at it yet, but this causes a consistent failure of one of
the poll based test cases:

axboe@m1pro-kvm ~/g/liburing (master)> test/poll-v-poll.t
do_fd_test: res 2a/1 differ
fd test IN failed

-- 
Jens Axboe

