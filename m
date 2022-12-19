Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9B650CC1
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 14:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiLSNlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 08:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiLSNlT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 08:41:19 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C1CF03C
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 05:41:16 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t2so9063416ply.2
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 05:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PbVcnw7aPS6IKAHy4Q2oItsiPHCr12afkxHIEH3YCzY=;
        b=qSv3UAl9cIjWfLyNMWol8BYXZdfW2p3RNkUKDejGkcKF/EwLU9AAkusIrpoGl7/jr+
         OQbdMQslNXF1gpXqpIt2vSuFxlJZyh/xLJQxma0W8Bud6+r0NJbG3ik7S4Zvq9pepmXv
         7Kj02O87Q5eJ+tq+s15pnIc4rZQ4Hc6B24VtShBC2BBtBu+51aYBP4F2TA9oPpbDy/6Z
         ZwAuNH76kvUMbw7JmWFXkUFOtk5PK4LFXyuafcENY535BYto+X7mwngtqVvP37oITXs5
         sk6rECPltSy43tYKrdaysQZTJFujLh96XyIzWw0SaYT4XRlcCWV5C7F+tBhmBxM5GIIh
         Cmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PbVcnw7aPS6IKAHy4Q2oItsiPHCr12afkxHIEH3YCzY=;
        b=ghhKBTqbvCiUJaWtn7/oDFM02+P/Wblp2r75ZhLcvQnJCd1JvT4BpQ7wSKNGEZrhAV
         z872PIb1DH3oB8wYlbMZYTlXX42vUUsw+CKsKWPR1EIh0siyOavEU5SrCEZzbkvXnXiG
         McTmnY0R52QNjI5DPtn3KISAEfFb2xB31SeKKC4qjIkRY5Iv3GcQuaprp4XvT//clwae
         lp2pwbcBcTgE8UxZuZYaApLVLG9bo7/2G5NZ1NH39W15uUYG4JqoFPJ9CbuVFE1hp7X9
         LGDVusEYKWUJaJFVX/xPNb6E6uv57y7Kd2Cg012rB2IGnOI51cPaEFgzEEpnVxHCyD29
         P7Og==
X-Gm-Message-State: AFqh2kq+BsfquYZXJTRXhT7aAf9abZmbMlBq1k3RdGrvzHRD3F1Yuebc
        X5VjE3YVrgDnWMMldtPPN9NdRkrIhgahOGysAC0=
X-Google-Smtp-Source: AMrXdXtVRN3tjyqlgE298piw1X/lwH3k16wP6Gc56CexoguOPJ3JGmCDTzesbPMUnJnBFNOkMlE3QQ==
X-Received: by 2002:a05:6a20:bb1e:b0:b1:d045:2818 with SMTP id fc30-20020a056a20bb1e00b000b1d0452818mr310028pzb.2.1671457275903;
        Mon, 19 Dec 2022 05:41:15 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 71-20020a63064a000000b0047911890728sm6295275pgg.79.2022.12.19.05.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 05:41:15 -0800 (PST)
Message-ID: <da59d091-48f3-e574-5110-3fa99ae0fc8d@kernel.dk>
Date:   Mon, 19 Dec 2022 06:41:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: User-triggerable 6.1 crash [was: io_uring/net: fix cleanup double
 free free_iov init]
Content-Language: en-US
To:     Jiri Slaby <jirislaby@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
References: <f159b763c92ef80496ee6e33457b460f41d88651.1664199279.git.asml.silence@gmail.com>
 <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/22 3:23 AM, Jiri Slaby wrote:
> On 26. 09. 22, 15:35, Pavel Begunkov wrote:
>> Having ->async_data doesn't mean it's initialised and previously we vere
>> relying on setting F_CLEANUP at the right moment. With zc sendmsg
>> though, we set F_CLEANUP early in prep when we alloc a notif and so we
>> may allocate async_data, fail in copy_msg_hdr() leaving
>> struct io_async_msghdr not initialised correctly but with F_CLEANUP
>> set, which causes a ->free_iov double free and probably other nastiness.
>>
>> Always initialise ->free_iov. Also, now it might point to fast_iov when
>> fails, so avoid freeing it during cleanups.
>>
>> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com
>> Fixes: 493108d95f146 ("io_uring/net: zerocopy sendmsg")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Hi,
> 
> it's rather easy to crash 6.1 with this patch now. Compile liburing-2.2/test/send_recvmsg.c with -m32, run it as an ordinary user and see the below WARNING followed by many BUGs.

I'll take a look at this.

-- 
Jens Axboe


