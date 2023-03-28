Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1BF6CB328
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 03:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjC1B3l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 21:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjC1B3k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 21:29:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA051BC0
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 18:29:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id iw3so10184553plb.6
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 18:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679966978; x=1682558978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Jdx37rOwHmakcXY70yxAvz0QRyJnQXhL1Wo5n+Z6Sk=;
        b=TLE59pC+XhSBCygxb2SEQVsD7yIPsQut3uSvtlKEheWJ2tzkUgAlKH9frRhvIaUuqf
         u5axdpbePlvEb5ATpAWhaGdNXbos48R6uC7ZbAzSfW8ih3A8GEldU1f1eowIC4Ws8IMo
         EPbbQFIlfrfrtOFpOQhheik/jRGwLZ9rpklmVa0fphD2Z9HZhm5FdEuXVVGsLqdAmDtY
         SIGWFw98Cu4PMyLREaSt7A8S1wFXdxRq9Nl8PtYX/CRUniY72xdzXRyIqL3NBFX2YE05
         X7Fr31TeC9wsGIOz8kcnXi2Dmz2K7Y7mMR+xfLM1Dsg5LC9t1R19fhB2CqXrWUzQFQ9i
         kTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679966978; x=1682558978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Jdx37rOwHmakcXY70yxAvz0QRyJnQXhL1Wo5n+Z6Sk=;
        b=oPaFETPy3gMbz4wV0RuaCWJqg1PZqrlSwxKxu5yvpf9Q4nM68iIVfpS++882U05K53
         qq4tCxRf1GSeJnBQ7jNBfPudn7q241axdFZ0aPKnUqb3a5K8UowiGGpB7Bwp3F8Y031H
         iMIcifYxqc5wQ0YYeGk0Wg6bvpaeMPQW9Hvz2ormpgtLC/AxtylIXXvtu5MmDD7Wk7Uo
         FBuyNpsnL+misGh7WCQ8goMqrePi+MzqwM4eI42y/1b1UZKXkTL4R1ZogeOWW4zango/
         0/DPdB0cV0yFahPHc/Xl2QUdjl/DDPeD7vY7ZOP2nb0Bdz4OdVSvYDD0ToSKR1Bt64Gl
         XVBw==
X-Gm-Message-State: AAQBX9dUXtK7D4U+8Y5AzSWtxoC0D+qBmWZK26vTpjnvvooJJRgVrwtr
        5a1ub7NESagZvvgDvgIxyfmfBg==
X-Google-Smtp-Source: AKy350YIXADcYKeGIQ+BYmeFKH3PssLjNKUaV/pDjDUzERdme6BuU5QYKfJDUlR2HCie59O54ufOqw==
X-Received: by 2002:a17:903:788:b0:1a1:bf37:7c2e with SMTP id kn8-20020a170903078800b001a1bf377c2emr11609653plb.4.1679966978475;
        Mon, 27 Mar 2023 18:29:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h20-20020a170902f7d400b001a0763fa8d6sm19820117plw.98.2023.03.27.18.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 18:29:38 -0700 (PDT)
Message-ID: <11651593-79d3-b21a-6441-63e1de5b39aa@kernel.dk>
Date:   Mon, 27 Mar 2023 19:29:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 7:16 PM, Ming Lei wrote:
> Hi Dan,
> 
> On Mon, Mar 27, 2023 at 05:36:33PM -0700, Dan Williams wrote:
>> Ming Lei wrote:
>>> Hello Jens,
>>>
>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>> and its ->issue() can retrieve/import buffer from master request's
>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>> submits slave OP just like normal OP issued from userspace, that said,
>>> SQE order is kept, and batching handling is done too.
>>
>> Hi Ming,
>>
>> io_uring and ublk are starting to be more on my radar these days. I
>> wanted to take a look at this series, but could not get past the
>> distracting "master"/"slave" terminology in this lead-in paragraph let
>> alone start looking at patches.
>>
>> Frankly, the description sounds more like "head"/"tail", or even
>> "fuse0"/"fuse1" because, for example, who is to say you might not have
> 
> The term "master/slave" is from patches.
> 
> The master command not only provides buffer for slave request, but also requires
> slave request for serving master command, and master command is always completed
> after all slave request are done.
> 
> That is why it is named as master/slave. Actually Jens raised the similar concern
> and I hate the name too, but it is always hard to figure out perfect name, or
> any other name for reflecting the relation? (head/tail, fuse0/1 can't
> do that, IMO)

Indeed. What about primary/secondary? And it'd be quite possible to have
multiple secondaries too.

-- 
Jens Axboe


