Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386C3376903
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhEGQtk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhEGQtj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:49:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA2EC061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:48:39 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b10so8512958iot.4
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wCVEYiQPOhsajnv2EopkiNZsWpsS1DnS1rJ4qfw28M8=;
        b=pcAbn2GFCsmwW1DYt/wKt2Lout0jCXFF2GPdcRgJoPA5zKO+1SYPErfjEXxveL1ixB
         9tSr+cEP3KSmavRVimEDZeBQPEGEW4cSGhpRXnM1FhGgwkn1rv1HZ54J0Ka7Iip1yDT4
         KUPH2rryYFlKgCyl7GlpXdd+1qUv43b0TtxTZ790buIKQj8bZpAJBsJbFgEViIXE+ZrJ
         oB/ukk36Cm32a3OD972oplG3VsA6WDxOPz/Mt/KmrMCnSLuW4JWMhQyGQS0cT0gCZ1WC
         VnELEIbeMIbIbz7JwyPQOKP/oIPngZlyYk+qYIHx/9L2vPn4JK79SYWZ0u747LHxnsje
         xUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wCVEYiQPOhsajnv2EopkiNZsWpsS1DnS1rJ4qfw28M8=;
        b=k/k1Z103l3oQTdiijX0yisMuUuL1/tu3tpeallbRP8UtNALaght/5fjAVzOvS3+wZV
         Wy3Vlx+N3q/VZ4+25fnOFjXYbd84tlQD7hsY+FVLndNLmc2ocoqNfafxSve/WPSg7vvp
         cYV7daLK8d7S2oIjtGaCmjbwdnxNFQpHGYlZAniumdvLlbxKCX9viSzYlCY+G8ZpQ2UD
         Qn6FFZXPRmiOFJAOPp3yksDg3d+qehXCEM3Y9kP97pD+lAdwjlvLP1/+DaXUaguvl5i8
         krnvzOtcYINw2bU7JhDwoH8YWGRItwttM2BeS68AkQvmkmSklH1hTuzX+IubPuBe/UKs
         +rJQ==
X-Gm-Message-State: AOAM5333yp2NpDQefY3X9FSGojS4gsCOqSLMOkV/pwqPjsHRT+fqTp3A
        sZFQ/Yz8ZM4QiC4nscl6qZyrVx47bTnneg==
X-Google-Smtp-Source: ABdhPJxQ11+BwUvb8mRLms+AZy6U121E4z5StVarUCyfm0B8jn6N5TzFqZKK+oYfEy67Kd+nuZc+lg==
X-Received: by 2002:a6b:6013:: with SMTP id r19mr8438575iog.208.1620406118169;
        Fri, 07 May 2021 09:48:38 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j2sm2416495ioj.20.2021.05.07.09.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 09:48:37 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: remove test_link_fail_ordering()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2038218a804134079c8883293f6d89a1723ac563.1620405748.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8bbb0ec6-e1c8-812c-7d2a-4232010118b2@kernel.dk>
Date:   Fri, 7 May 2021 10:48:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2038218a804134079c8883293f6d89a1723ac563.1620405748.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/21 10:42 AM, Pavel Begunkov wrote:
> Apparently old kernels were posting CQEs of a link failed during
> submission in a strange order, kill the test.

Applied, thanks.

-- 
Jens Axboe

