Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F77C591733
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiHLWQx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:16:52 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1717B24A7
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:16:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t22so2172952pjy.1
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=xPw2XB4KFZwGtlKtwiWBo1xUU6ayDzaBeUhc1qPe8ps=;
        b=RZI/Ta6MNkhrpE8UEQRPxPgjuoF6kgBxtyNruj+G7bnMWka67VBy5A2ACOKmTSFcSq
         MdVXanfPUGLFtYe+TF7RfPdB8lWGX/3/D9k3H8GqpvZ4LWFmTCOmFYEuI1TqM63MvB/N
         LJc/srodhW+lNRCuvmbIPdIesveFBcBPEWlbl9lILwGNXtLSxPo1LAj6xr6IeDKLVpTV
         fTeZAr2djP3+C4LoLxJb6+/f8RqTEVqsKtpXV4I4dnlwHN2Xpwb7/ZswFpkImh8ekFF8
         HcxqwUzi/oYV8wxKzWz7Ge7ERmWn7+CFe79hAXBknlJXV6yLvmdQym92908mLahe7kMw
         BdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=xPw2XB4KFZwGtlKtwiWBo1xUU6ayDzaBeUhc1qPe8ps=;
        b=RXrzRKf9v1uTvmeAyeXZ0ybx/41HqH5noJrujuHWDQwZ2a49V5OtrW10AHvCC8UB3j
         YUy4RLuNVUaN6sCAd3gKSlyaS1xcIpnbvcU4Ux6qSrDMS0fjs88e3Fy40bWG2PNF7zvc
         pb55ad9LvoLnKOUxc57nZnHVRd3WdjroQqeFXtwlCR0Ag/Yn517szjOLkcDE1J/lhER3
         ktsBDPUThmYbPXSSDSwyR3N4Oqps6q0ffGsf6L/CizuZnNjnqeKpd7GDiciN/BvMzER9
         jlGlmKhiJvolzXNeWdMWfgpwOfCmr8yNlM8gzOvRmR3vsHJNSb8quabOmWRdFWiKyb6B
         zACw==
X-Gm-Message-State: ACgBeo10/cNbSx4Sx7vkJg3mynLS6fIHiAJ6tR5w+4bRG1LXQlcgHUhG
        3plzYpHIVyzmsri702PPBPy5yA==
X-Google-Smtp-Source: AA6agR5SaOsnrcM0n+Qu1l4QGVGIkWr13cSpeesC6DfeO6LV7RUmfr2SNrRrGPaeYig6+yjvq7vphA==
X-Received: by 2002:a17:90b:4f8d:b0:1f3:1785:8981 with SMTP id qe13-20020a17090b4f8d00b001f317858981mr6306806pjb.227.1660342611480;
        Fri, 12 Aug 2022 15:16:51 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u203-20020a6279d4000000b00525496442ccsm2103054pfc.216.2022.08.12.15.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:16:50 -0700 (PDT)
Message-ID: <9f5a7fed-1ccc-8dc3-31c2-b3c9b8f0d0c0@kernel.dk>
Date:   Fri, 12 Aug 2022 16:16:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <CAHk-=whSsFdh5Z+J_bbk11NUrzmaXoBJiMGfeYyXdK3bn_cT9Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=whSsFdh5Z+J_bbk11NUrzmaXoBJiMGfeYyXdK3bn_cT9Q@mail.gmail.com>
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

On 8/12/22 4:01 PM, Linus Torvalds wrote:
> On Fri, Aug 12, 2022 at 2:54 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> And yes, on this latest case it was once again "struct io_cmd_data".
> 
> Duh. I'm a nincompoop. I'm only looking at the BUG_ON(), but
> io_cmd_data is the *good* case that should cover it all, the "cmd_sz"
> is the problem case, and the problematic stricture name doesn't
> actually show up in the BUILD_BUG_ON() output.
> 
> So you have to look at where it's inlined from and check them
> individually, and yeah, it seems to be 'struct io_rw' every time.

Right, see my reply - it's struct io_rw because of the kiocb changing
size depending on what layout is picked.

I sent a hack to fix it in that email. I'm _pretty_ sure this is only
io_rw as we generally don't include a lot of kernel structs in
per-command structs. So while it's a bit of an eye sore (and moves io_rw
into the public domain rather than be rw.c private), it should work
around the issue.

-- 
Jens Axboe

