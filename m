Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39B3EE023
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 00:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhHPWxA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 18:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbhHPWwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 18:52:09 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78346C0617AD
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 15:51:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q10so25800270wro.2
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 15:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0O6fa82Nh0Fr5Z9UH6t72hdFroqOiXSZ3EmXeIatJgk=;
        b=battb1+KMvIqR1gWgOzzIrdyEU9VNLklzR/s1yOTBaMLZZAP6/6px82t7OaAds2+vJ
         Z5tLB2iZ04uutj7Mqf3ovCUDxIZvT/9PLcUSvhpwjkLIB0LvmSEyhJzHDQ8DKBLQnjJq
         4Jr6cSsLf9hlGDvG4QNIz4ZJi82FkgRRuBg11ZCUmT2DFg+KdMbn/7U3TFLGNW4WSkhV
         ZqhZXE8bptapo+ay8jSVcKzy0bIV87SY/ESt6WSkSqVS6DBI4uaDcy0Lc3GT4f8ayIN0
         di96dVBfhauQzErPK+ZDl4ShxmYE5LdLNmzBoCVdoHo++oDWOG6rV18Yg0l94ApPJj4t
         ix1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0O6fa82Nh0Fr5Z9UH6t72hdFroqOiXSZ3EmXeIatJgk=;
        b=m7r5ezSU3pZgliFm0rkzcHgFAK0o36TYkwA/TWjficmvlSc1QarrIdQxpLAOEMaGmZ
         BUXH5Zw9uqJ5uXufu/p6/MuC2UAmXes/ex+I62Zoj1N+EV6DG8EV8myUqKV/th8oWEYn
         JMLxYqKYlCaLQA3AScVS+22o28FaTZX9URm60182yF4NDW4hVRAX4zFMv32REUv2UCDt
         Bx+VaKUVFHpU+TlCsKEfg6kD4DS2PVSEt/XC24GBa7mCWgT0F1EBanIaQd3puXlRsGqG
         +dHin/JfmTPrEFvLjuM1JQa8sLU5jRU1r54GRm4eWlF7RCEtguXa9i7Ri1xj/8ETuZ1S
         ePMQ==
X-Gm-Message-State: AOAM5325QNxfl7pYPuYpLzVI25isOGRmd4jdGKkCv5dNNp3AoXb7BTX1
        koiKkd9t3ktkGdvfuttSA6U=
X-Google-Smtp-Source: ABdhPJwyafgf7ruq++vian04cSdG5biEQnz/hQiGVFLI3N4LYJFWLsHCbNqzV7C/zSxH+4eBn7axeA==
X-Received: by 2002:a5d:674b:: with SMTP id l11mr350885wrw.357.1629154295140;
        Mon, 16 Aug 2021 15:51:35 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e3sm188088wrv.65.2021.08.16.15.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 15:51:34 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: don't forget to clear REQ_F_ARM_LTIMEOUT
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com
References: <614f650abdd5fee97aa5a6a87028a2c47d2a6c94.1629137586.git.asml.silence@gmail.com>
 <16575c24-51d9-0946-4a89-d4320b51d79b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <6e155bdb-1a75-f415-4eb2-db543e3b2625@gmail.com>
Date:   Mon, 16 Aug 2021 23:51:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <16575c24-51d9-0946-4a89-d4320b51d79b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 7:49 PM, Jens Axboe wrote:
> On 8/16/21 12:16 PM, Pavel Begunkov wrote:
>> Even though it should be safe to poke into req->link after
>> io_issue_sqe() in terms of races, it may end up retiring a request, e.g.
>> when someone calls io_req_complete(). It'll be placed into an internal
>> request cache, so the memory would be valid with other guarantees, but
>> the request will be actually dismantled and with requests linked removed
>> and enqueued.
>>
>> Hence, don't forget to remove REQ_F_ARM_LTIMEOUT after a linked timeout
>> got disarmed, otherwise following io_prep_linked_timeout() will expect
>> req->link to be not-zero and so fault.
> 
> Since its tip of tree, I will just fold this one in.

Perfect, thanks!

-- 
Pavel Begunkov
