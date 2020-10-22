Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC7D296459
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 20:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901446AbgJVSBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 14:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368653AbgJVSBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 14:01:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D16C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 11:01:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z17so1859920iog.11
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 11:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xneyv2CBRlNa7+nc3nvRHuyAMGPK/uFN6CNVCKFHBww=;
        b=ZMxb6KM+o7Vuhr7vOZjj69lYEkhillpjzqcETv0REtgd85ZVNSVR1StGT/l5iQ/Bf1
         IDUNNiGg8zxrjw2myVM7mP1O2ipL/YQ3YZFhInQxKVEnK/+zPITQVelvn/sMGTYkoYnH
         EJXic08ICy1NApQ4EqaH1/mCNTYZwYp1L6YmnCpjp2q1KASBoRG4VaeNqoxgQ1DrjWFV
         hxebVBIwvrRTNg+znY8jhQ+wLVJfj+0rYiB/rqyk3b2zzcW+yU9cuJ70f7dbz7qsGWyc
         KzoWSRPKWuam7B9ND7oxsTw5EiwfFe2YeTQkQWN4UAQ35EwoVxay78TnTDWjOuRhf3Zy
         x0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xneyv2CBRlNa7+nc3nvRHuyAMGPK/uFN6CNVCKFHBww=;
        b=EM1pKKCy6Za3ZlI8Q0KoRLnqVozcUi8s51J2RVqMfZpkHQj6PSP+yBEPERQhsQmyAx
         zo5GS0GcFmgCsdkmiFJ05Tnpth00rlncbq8g+FyxDeMSwCz8yf38r/ADDMrXQM+QC/p0
         aHrBOKeuq/A/3xmsWjkiHLThz5gwtuD4irWWTSoStUMd8jd4Dabpwz+0xsGBipdVo8ky
         4/Ez0tYGoq1yvX+pfIGGfg1pV5iV6U69THDz1MTjRlD00TJa07sK55OO1EL0urTBZ2Ds
         oOt8bvafxzqdqWJ6R1zVq/zEbJZqzpBrMO0HkVIIEeJCcDTmCB7bFHMYekSSPzitE1Hw
         sJXA==
X-Gm-Message-State: AOAM533kQ/xBpbDeJgUBYT26EvOgvFjzxTa7EAuIB84GqrgmPqHzxjpk
        exO3ZZPV8I/Ce7a6nNIDwvzSyshTgIm8PQ==
X-Google-Smtp-Source: ABdhPJwRtyhMnIsb2bWtLNutlkhy1uMT9SL8errpnvI8WxjgYMJ2oPwHLXQi/Y15fsc8MBlhpSfxzA==
X-Received: by 2002:a5d:8848:: with SMTP id t8mr2785322ios.152.1603389668655;
        Thu, 22 Oct 2020 11:01:08 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v9sm1252655ioq.41.2020.10.22.11.01.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 11:01:08 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: remove req cancel in ->flush()
To:     Jeff Moyer <jmoyer@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
 <x491rhq6tcx.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8b1a53d2-d25f-2afb-7cf7-7a78f5d3ba29@kernel.dk>
Date:   Thu, 22 Oct 2020 12:01:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x491rhq6tcx.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/20 11:52 AM, Jeff Moyer wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> Every close(io_uring) causes cancellation of all inflight requests
>> carrying ->files. That's not nice but was neccessary up until recently.
>> Now task->files removal is handled in the core code, so that part of
>> flush can be removed.
> 
> I don't understand the motivation for this patch.  Why would an
> application close the io_uring fd with outstanding requests?

It normally wouldn't, of course. It's important to understand that this
triggers for _any_ close. So if the app did a dup+close, then it'd
still trigger.

The point is that previously we _had_ to cancel requests that had
->files assigned, due to using a weak reference. Now we no longer have
to, so the point is to just get rid of that previous oddity.

-- 
Jens Axboe

