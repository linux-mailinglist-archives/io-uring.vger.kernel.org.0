Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94C3F9F34
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhH0SxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 14:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhH0SxN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 14:53:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E27C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:52:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so5020146wma.0
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RuJT5Tj3cQZoQEN6mi/w24dLT7wCLVZpQTR9gRx51YU=;
        b=qD8+q4SSgnvh5Qol/l8EjKdk+aLW0vYA8fRWxQdXNRctESOterObreqwfooR4H/siX
         ZqB3eDPyYe8RugCkPXsLWaK+G5VRtidbX3JmMJyaButvNO7KsJ6+keZQuoxmt5oax2db
         EmeUvhZ9LkQLFAjomli8QE0mHKfJgYAmfuBJx9b9WpDfR3Chk8Du+BvTc/4iTM2y1wxd
         fvdsyYu6R4gM7VdsZi2H9RZrZH4tYZnGw81pi+M2SpjMn2GXi9JqcqF+Rq0ofVdKAlK3
         Ot+1TBJIEdSzDkHLb91DHaiFrIg9VCE568C43cvpRYArsg+I8M4qGTnnabMSSuvrcEBl
         NRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuJT5Tj3cQZoQEN6mi/w24dLT7wCLVZpQTR9gRx51YU=;
        b=KQGxu5RgvB/lZISQ0Lpx/xugw3ayXKcEng0rdKbKmQeEDZjA+uhANBZ9lBS+C7G0ac
         GVNxaM4JstEEi7Hnd7IkRib9BxE4KTIXTS0EudfEzcIwe1kNCMl5VAn+r6HRoLDZX4kX
         bkhxAbvkvblMrSlvohLxxmzBUZkx8C2D1/FxjtPSPrz1y71F6k2zzouVeAqLINTePi/1
         WafKx+rQO74g9Me0DHir+4U+BbnMx/Z7Pwpmc+b+2oSPIVJDUTLXF+Dvprglgpca4Upp
         +QK0VoUyUexXLlcOBqaSTCDMmW8idMnaBvy48MF4I0xlafFD2gRPI90l//KKjDEeJEOl
         MY8A==
X-Gm-Message-State: AOAM532dyAimtZ7FqTvlmdyfqdtN90Uw6YweJnZ62bQK0Ai8nHI3dm4t
        n4ddgoi/fb1f34NwJn4VDNDm1trCaZU=
X-Google-Smtp-Source: ABdhPJy/EeCdtASZdeInuBo0Z/NA+p/gcAJzK7EB/5q50XGKrFjXfWKFy1jTCu1rJT2YqonQqAkK8A==
X-Received: by 2002:a1c:e919:: with SMTP id q25mr10697943wmc.28.1630090342239;
        Fri, 27 Aug 2021 11:52:22 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id u9sm7033185wrm.70.2021.08.27.11.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 11:52:21 -0700 (PDT)
Subject: Re: [PATCH liburing] register: add tagging and buf update helpers
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
 <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
Date:   Fri, 27 Aug 2021 19:51:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 7:48 PM, Jens Axboe wrote:
> On 8/27/21 12:46 PM, Pavel Begunkov wrote:
>> Add heplers for rsrc (buffers, files) updates and registration with
>> tags.
> 
> Excellent! They should go into src/liburing.map too though. 

Hmm, indeed

Should it be LIBURING_2.2 or LIBURING_2.1 ?

-- 
Pavel Begunkov
