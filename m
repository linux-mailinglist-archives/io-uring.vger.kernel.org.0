Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40E46F9DB0
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 04:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjEHCWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 22:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjEHCWO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 22:22:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6274B2695;
        Sun,  7 May 2023 19:22:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f37a36b713so40581885e9.1;
        Sun, 07 May 2023 19:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683512532; x=1686104532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8BqRI8xckUuiTetI+oWbedIhDWXvMt/WNoJrYRkwROY=;
        b=kNV+iSNaYwjLPsnYaNwpAPejOLI83QKH9x4VUqExG6LQJbOC7nmV1CkbcOWpuQOEZh
         pJZ4GwTLTXl4Sj7TaIgv6K2qzE7CCW5XreRAqfU8oufV+gBjwE5MLPvvTSFso31gd0WM
         DVtbHtTMCHcrFpNYSzHV+04ISA9eJdMYf3UaNobFJB39PObKQ7nhLX/TmcVosSE31IE/
         vimWGY3OKaKLQtTXrPok6UZ1sg0g16RPYk7kMjgsV9b5Y+EbPWTiaPCpVwc82G4yafwo
         i2ccDOq8i7JJ2mrWrSVnSwue3BM5GXYZXnUXqw0Hzyvhwya9uQWJGCKdT4G9s1zGHTmr
         Wt1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683512532; x=1686104532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BqRI8xckUuiTetI+oWbedIhDWXvMt/WNoJrYRkwROY=;
        b=Ur/MxhEWWUXhz6eBtWdxlN1InGl0s0Ij9k3AEyRVo+CTumCUXPxzvOLq3U2c3GEFUp
         YzjR8kIfhxiqZsHRRZQM1OtsmqpQLkrpBMgG0apjOdEz3MhCdxPlWSE0uKTuoXcuwKFZ
         RC/E55C1jB/JTUVVshpAG8ywZiYB/CXGwODiX3i8eHUnRcqx5xLzuNaZtw3Rawyfxk7F
         KZqCifELgcpL79UO2oxmfzxe7O18fqqE37PS8UtzYFZ589/0cXMis56Tui9wYQFuucIB
         Rl0z7FdgMXCIDfToX5xUKrLl4BnvpTDn8qQj20ZqBswF22bQepNbPER0k+0aWTqkdCNe
         U0vA==
X-Gm-Message-State: AC+VfDx+dTlY0unZfaYv0CVZQYsuBbMb1AlTB6NORsWCVO0FftCy6kcC
        adLQXiQVXQZwsmUZDIXZie4=
X-Google-Smtp-Source: ACHHUZ5QGWjbfDj0vSBgRk8qSRZJleSs23j6grx5VOgIcaGcGKs23aWJO03b0x1fBf5Saq4A8YO+Dg==
X-Received: by 2002:adf:fdcc:0:b0:307:7e68:3a47 with SMTP id i12-20020adffdcc000000b003077e683a47mr6037837wrs.37.1683512531565;
        Sun, 07 May 2023 19:22:11 -0700 (PDT)
Received: from [192.168.8.100] (188.30.86.13.threembb.co.uk. [188.30.86.13])
        by smtp.gmail.com with ESMTPSA id e1-20020a5d4e81000000b003062765bf1dsm9757750wru.33.2023.05.07.19.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 19:22:11 -0700 (PDT)
Message-ID: <b5139d5a-c41c-48f6-2468-ae70a728a213@gmail.com>
Date:   Mon, 8 May 2023 03:16:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [LSF/MM/BPF TOPIC] ublk & io_uring: ublk zero copy support
To:     Ming Lei <ming.lei@redhat.com>, Bernd Schubert <bschubert@ddn.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <ZEx+h/iFf46XiWG1@ovpn-8-24.pek2.redhat.com>
 <41cfb9c2-9774-e9e1-d8e7-4999a710f2e7@ddn.com>
 <ZFWviQb7eKn/eBi9@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZFWviQb7eKn/eBi9@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/23 02:38, Ming Lei wrote:
> On Fri, May 05, 2023 at 09:57:47PM +0000, Bernd Schubert wrote:
>> Hi Ming,
>>
>> On 4/29/23 04:18, Ming Lei wrote:
>>> Hello,
>>>
>>> ublk zero copy is observed to improve big chunk(64KB+) sequential IO performance a
>>> lot, such as, IOPS of ublk-loop over tmpfs is increased by 1~2X[1], Jens also observed
>>> that IOPS of ublk-qcow2 can be increased by ~1X[2]. Meantime it saves memory bandwidth.
>>>
>>> So this is one important performance improvement.
>>>
>>> So far there are three proposal:
>>
>> looks like there is no dedicated session. Could we still have a
>> discussion in a free slot, if possible?
> 
> Sure, and we can invite Pavel to the talk too if he is in this lsfmm.

I'd love to go but regretfully can't make it

-- 
Pavel Begunkov
