Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE7B4ED0FD
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 02:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiCaAqf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 20:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiCaAqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 20:46:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DA055228
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 17:44:48 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f3so19196639pfe.2
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 17:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TVB6/4mLWSgTuqbrm4j6qv9o1fnWRCStFsVM2qq0BvI=;
        b=mbx3m6I/DCKDaFnX8YefZza/gbSGTY4jUG9WhrllqIXqSdV5ZlVjMQWizo1RKCXvXE
         P5XuBCp8lTf4CYYo82TxvSLX90gXG0h+6dQngXxzlA1gNlczkdRPdPk6oIRlF01GEDVI
         lTYRSMjtkQHyB23G35h8xp2dDBaHeV9V82vAvvFmgxK801dxlUTVqIh4EStXDcFreeXG
         Il8uZ3y0Vyc2ggvt5VfV928gL7NkMLnt0TBvXEsedIsG9EpDCRuJRzyu446mSa3yWRIV
         S34Q732yN5DetlnDIgcC+Izmsc0JhhBnWd7+maRLQxcAk8CtZ0COOCKQ/c6ZyNChM8Rq
         csvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TVB6/4mLWSgTuqbrm4j6qv9o1fnWRCStFsVM2qq0BvI=;
        b=YYBGmjFnqpi/bSl8xdJpfx0T6bqHEXGkQbXN99DVciMURSn4Ci6g8AmJw4SO9NAANp
         DQQZmemyAXIszV1HIvMvrgWwAw1TEsU7UCyg+Us+dqTW/nkWlVTZ7Fe0bhTRnXg8Rf9k
         px7sKbFyE3rUgl4/IH4KY3zDYnEFKDjHIWgWGkVLtTEb1ojcYbHgZ/sy0bgD6Ymskzk6
         kCYztzwK1U4BMJUFHLwzew/VyQ9laUmbmDJD3moj/PyV3dkJYavFMahwTM/lx/tc1q/X
         9f+Q3MMY/FPAfJOFDGc9ZAngDZgETydouEjlLTrSvM6pQftoH+YLMzs3uuYKrf7Pnsd2
         TuBg==
X-Gm-Message-State: AOAM532vkCoUFRiwqlCu3+0IW47WYGUOkpJ8g6V3mQeW5CsuoxpmI8AB
        2xOcc+gkZZFCBmrKSQaKBCcMUA==
X-Google-Smtp-Source: ABdhPJzq3l6Jk4AkO+2F4NEQ63KyFqpluAYudVqIVUA3ie8DE+G3FAMZHoiMNWGbwv4mHnLVyWFg1A==
X-Received: by 2002:a05:6a00:140c:b0:4e1:530c:edc0 with SMTP id l12-20020a056a00140c00b004e1530cedc0mr36218087pfu.18.1648687487902;
        Wed, 30 Mar 2022 17:44:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9-20020a056a00198900b004fafdb88076sm22647910pfl.117.2022.03.30.17.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 17:44:47 -0700 (PDT)
Message-ID: <a6ba57f0-7c8d-f6d7-47ef-9378d002e9a5@kernel.dk>
Date:   Wed, 30 Mar 2022 18:44:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
 <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
 <20220326143049.671b463c@kernel.org> <20220330163006.0ff1fec2@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220330163006.0ff1fec2@kernel.org>
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

On 3/30/22 5:30 PM, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 14:30:49 -0700 Jakub Kicinski wrote:
>> In any case, let's look in detail on Monday :)
> 
> I have too many questions, best if we discuss this over the code.
> 
> Can we get the change reverted and cross-posted to netdev?

I'm not going to revert this upfront, but I can certainly start
a discussion on netdev so we can poke at it. If we end up
deciding that the API definitely needs to change, then by all
means we'll revert it before 5.18-final. So far it all seems a
bit handwavy to me, so let's discuss it.

-- 
Jens Axboe

