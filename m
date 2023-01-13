Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36916689EA
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 04:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjAMDKN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 22:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjAMDKM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 22:10:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190E85E644
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 19:10:10 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so25645001pjk.3
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 19:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C90ocOCbYhc9KPmslTn+kJF/0Z1JIADREHRqXAQ2xPc=;
        b=2TQ1+RKZQ3MCeMpvGj5KJi0VAyT+C5F/4PPGTxF6hToUg1V14iAyazYjPcNpbhnw/b
         FDDMXal+Dbi35IjtmHXyO6/j5J/DyCJ3UAG/eMN3cH+vHo3LhhxV+QVE6We0BSmDQkAC
         93vQGN80wHFcJWCYDkj1H7/X6+Q6yvJatoRD5NgXHbI7Fs9scJdvx4MfYhvE1TFYMTDl
         6e0DrTb/8+GlCn225Bkkx23B+LCwIiDOr+09+jcVSkTp7gtoXrlU2B6UozMhxk//gT4+
         hjJC+MRkP0dkj2zCHHVwe+PP+stWPO0j/N70XPmAhDB5qzQyInc3avdVcO0v8sjtBFhd
         W8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C90ocOCbYhc9KPmslTn+kJF/0Z1JIADREHRqXAQ2xPc=;
        b=AP/DGi1kgpodsUUKheV73UMIKqXoBJKWiWEkwgGfu8mm1qzoInSXm+l0sO6gxwkRhp
         89y1Mq2A/jP505s5e0vtH4+ZwynPv1XHEOk7DKeKYJT5AzhANMMhzlFNwdspMNuymXv3
         GhGjFqC7r9Va4TRfvCK+T7PBse349hS9CODVUcwiM6CJc4OdEZxtlntWEfGnbPvmTsCn
         tc/+LGG1upq8xzoQVmXqTKaZiBLBDml94PWspGsv1jYE/dfecHomRY9/jiB1Y5s8dYgy
         KEZ2Rhs4BpsFxsXdFP1Mod7gCpCeFJKwVRx7TslQBPGqmB77r2mo/ZeDC7vsowEuhb5v
         fSPQ==
X-Gm-Message-State: AFqh2kpBcUY8fFjLxdaJ0CrjorMm32Oar40/UNpZArPJ1Aj9Xu7wd1wp
        B0JWKX9/qFBC/uFLTkq7Ivz0bQ==
X-Google-Smtp-Source: AMrXdXvFLhchaoEsq2N6JhlXRZAj8tpW+mzYDUn34CBDcg7V2BJHyDpEQKXDzzvA95QhpBRpFbAKuw==
X-Received: by 2002:a17:902:8497:b0:192:c804:89db with SMTP id c23-20020a170902849700b00192c80489dbmr8876861plo.1.1673579409550;
        Thu, 12 Jan 2023 19:10:09 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902eac600b0019339f3368asm7915119pld.3.2023.01.12.19.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 19:10:09 -0800 (PST)
Message-ID: <c3f1a97e-8a5b-5f8f-1e36-359d8319131b@kernel.dk>
Date:   Thu, 12 Jan 2023 20:10:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000694ccd05f20ef7be@google.com>
 <746dc294-385c-3ebb-6b8e-7e01e9d54df5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <746dc294-385c-3ebb-6b8e-7e01e9d54df5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 11:11 AM, Pavel Begunkov wrote:
> On 1/12/23 10:56, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> WARNING in io_cqring_event_overflow
> 
> #syz test: https://github.com/isilence/linux.git overflow-lock

I picked this one up so it can make the pull this week, jfyi.

-- 
Jens Axboe


