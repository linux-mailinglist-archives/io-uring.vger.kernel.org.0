Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC962DD40C
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgLQPWI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgLQPWH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 10:22:07 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799E5C06138C
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:27 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id q1so26166639ilt.6
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 07:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mAyDDrN3FAEbbyTKcPSOTcQfHKZCWuJ5iGwODR3U7cU=;
        b=dssQyFKWbUMc2J5tVItiDkP34tOXcqPzfL4nzAiQKtcyOA0FOa/wnsmSg62hWSYRMk
         T55FWcHZjpM8fAoLSUcvj/rhbZBXNgzEKCXaq+2K11rrospy6BJpYjVcLoR9uJqUEECS
         ox4cI80pkesSLa4ETKci2sJkY2jeWFFUoDGDqzAlKCXD6dcYTwyX6yLTMVnwmiONI/cV
         QQn2e7UYDuwnfPZwhfYnlRsuHHP/W6k7xmGVuMW+VMqKNvW6ec3pAy9YGnu1zJBmnZsg
         NjI5nTjlTaaNJ+hl4NSgOqjl+qrEcjOlHiKqz9P5gBC8rMnhzCvOPrg8VLtqSzEZLOaC
         1ejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mAyDDrN3FAEbbyTKcPSOTcQfHKZCWuJ5iGwODR3U7cU=;
        b=mvV+PiRRB+vTYYISrrkVIs8nDnAnow4D8Aa9gqz2CAzzY9Di20Tnd5CGsqeFteBGHt
         MZoz58rEu4x4Gik8v1gZmR+HasQAgzw6q5f4lkj4h7kqUmQW80ceThr1+RYUS5C7S4Bz
         CagyK5T4rcfvD0ERlhBNNHW6cWQmADXmqg4rh+ShJVI7PmFYR7BS5DvWdD0F8Du4fC2i
         hZ8rjdCsi4KX3TFdWwDjQus4M8g5l92X4kAxMj/9C99NVNw7HvL0WAbdqKO0KAK9oGZn
         5o2k4oIDTq4sSrB508AOUO56h7dY6/dRvRbXdesrjMuz37q0LXC3spuEe/YI7TiFONiR
         cAHA==
X-Gm-Message-State: AOAM533ZrnxMwK7SgmL3wAkdsTSJvgpXXqKXH26P2MpHT0TlyKSH+QFx
        +f14U2WEhghtlQw4nw+vxYiDp4Dug/7MIw==
X-Google-Smtp-Source: ABdhPJzohoXmjDIYwvAYrMey7BUsXhYNbdXTEke+Bqf2oNkO5vcuGv9s5DmK8vbi28lolyoD5bfDfg==
X-Received: by 2002:a92:cb0d:: with SMTP id s13mr51519417ilo.73.1608218486594;
        Thu, 17 Dec 2020 07:21:26 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l78sm3612287ild.30.2020.12.17.07.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 07:21:26 -0800 (PST)
Subject: Re: [PATCH 0/5] fixes around request overflows
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1608164394.git.asml.silence@gmail.com>
 <f0f7de4e-1aab-e28b-87a5-88c4c5cfd517@kernel.dk>
 <04da3460-dba8-00ed-3f94-0c09a3276145@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <63bd2886-88b7-4759-c4a2-ee9aa22d1e53@kernel.dk>
Date:   Thu, 17 Dec 2020 08:21:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <04da3460-dba8-00ed-3f94-0c09a3276145@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/20 7:38 PM, Pavel Begunkov wrote:
> On 17/12/2020 02:26, Jens Axboe wrote:
>> On 12/16/20 5:24 PM, Pavel Begunkov wrote:
>>> [1/5] is a recent regression, should be pretty easily discoverable
>>> (backport?). 3-5 are just a regular easy cleaning.
>>
>> If 1/5 is a recent regression, why doesn't it have a Fixes line?
> 
> I was lazy enough to just ask before actually looking for it.
> 
> Fixes: 0f2122045b946 ("io_uring: don't rely on weak ->files references")
> Which is backported to v5.5+

Thanks added, and applied the rest.

-- 
Jens Axboe

