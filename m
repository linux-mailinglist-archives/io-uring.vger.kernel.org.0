Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8E1226B1E
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 18:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgGTQjf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 12:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730966AbgGTPtF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 11:49:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD51C061794
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 08:49:04 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a11so13734980ilk.0
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 08:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=D/CA+/3/bTndVqHDVfOkxSHtDGUPSGt5x3VVKQfqZbg=;
        b=WGiBVFDxkDK9ZFg0IrwsBU9TGmD+ri9d6HGdShiF1Ll+N1iHXGFQmIfLUSjif3Cmp+
         AVeUuZqUIux5ykvvGzRtLUa1DylQFhVVOKR7da7PHAgVzIKkJcHa7BONkoYjb/tCizfw
         1j4ywtzIffpQMa6dfjP3vGDCMKE5fn+PykRLQgbP431T/6VxhaOEmuCQyGkis6crNs5T
         HmAg41n3TmKIBU5R3qZ0YW8M+/EMEkE+3TpK2YDfQrsc5H8hJC9ES3ygxd+39EonR6Cx
         BDO3PHM1BrFlmkKI/BU0weuKzZ9PE3fTQTc4HoMAoDdTfYmVdfAxVSUf4Jd14SZHpD+K
         LVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D/CA+/3/bTndVqHDVfOkxSHtDGUPSGt5x3VVKQfqZbg=;
        b=WpdW48cVyB5mVE3bXxGyg/kXGkDwOBmP//6ESikjpGxh3x8ylRqkcTXv347S4di4SL
         YQ7iBldMJojrwIinSgmSAIzlRbzAcblzGpZ2+ybQV2V9dB/KJNfPw738MEAub3EbOFLD
         LymWYlk7eKzSp/wCZ34PqzPlbkysu+AFqX/tae7xM6CdMt6lu4xOdgAwoCji0G1MGYI9
         PQNdSCA4HQBeXQoi/UuQVKMEiap+VMM1ayQH4oVQcjIXtG15bQWtX1ecsr7B2Tr8nnd0
         z1M0KEP7wAwmDYyGhLIvLOTEFEN9h7NFv+F6qFwaWcMNDxhnSeFARqay9ZlpZWCmIbIt
         QQWQ==
X-Gm-Message-State: AOAM532oELvRRqjA04u/tkmw4r9oYjslxCKar4mK/sF+2aYpe2gV1vzy
        M+HEGqXhpT5AnJOxempYnoVR6Q==
X-Google-Smtp-Source: ABdhPJxoefCUr9kZLZrdpjB1/kG/khSkCyqABdVEAysM2MGxbfvjcaNVbWEaW6P3bgONfYG5iyq/kw==
X-Received: by 2002:a05:6e02:605:: with SMTP id t5mr23516270ils.116.1595260144075;
        Mon, 20 Jul 2020 08:49:04 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z78sm9474809ilk.72.2020.07.20.08.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 08:49:03 -0700 (PDT)
Subject: Re: [PATCH 0/2] task_put batching
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1595021626.git.asml.silence@gmail.com>
 <cf209c59-547e-0a69-244d-7c1fec00a978@kernel.dk>
 <b01e7f2d-d9a6-5593-3afb-5008d96695c6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2aa8de0-a2d0-3381-3415-4b523c2b66a5@kernel.dk>
Date:   Mon, 20 Jul 2020 09:49:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b01e7f2d-d9a6-5593-3afb-5008d96695c6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/20 9:22 AM, Pavel Begunkov wrote:
> On 18/07/2020 17:37, Jens Axboe wrote:
>> On 7/18/20 2:32 AM, Pavel Begunkov wrote:
>>> For my a bit exaggerated test case perf continues to show high CPU
>>> cosumption by io_dismantle(), and so calling it io_iopoll_complete().
>>> Even though the patch doesn't yield throughput increase for my setup,
>>> probably because the effect is hidden behind polling, but it definitely
>>> improves relative percentage. And the difference should only grow with
>>> increasing number of CPUs. Another reason to have this is that atomics
>>> may affect other parallel tasks (e.g. which doesn't use io_uring)
>>>
>>> before:
>>> io_iopoll_complete: 5.29%
>>> io_dismantle_req:   2.16%
>>>
>>> after:
>>> io_iopoll_complete: 3.39%
>>> io_dismantle_req:   0.465%
>>
>> Still not seeing a win here, but it's clean and it _should_ work. For
>> some reason I end up getting the offset in task ref put growing the
>> fput_many(). Which doesn't (on the surface) make a lot of sense, but
>> may just mean that we have some weird side effects.
> 
> It grows because the patch is garbage, the second condition is always false.
> See the diff. Could you please drop both patches?

Hah, indeed. With this on top, it looks like it should in terms of
performance and profiles.

I can just fold this into the existing one, if you'd like.

-- 
Jens Axboe

