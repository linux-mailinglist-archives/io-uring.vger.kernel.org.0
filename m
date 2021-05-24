Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFDE38E3C5
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 12:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhEXKSU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 06:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhEXKSS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 06:18:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC5C061574;
        Mon, 24 May 2021 03:16:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so10687793wmh.4;
        Mon, 24 May 2021 03:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WfBOKQ6YfV+bOowYEXO7+f3CsFRgD5WWO3dsN5dpEOA=;
        b=klv60MjN+fwjuGj07Oe1a1FBFwom+y11oHA9u8AmIvqi/yHZ3BA4/2hlERzyNO4X3h
         tvKNlGXyPd6v3yJdeCKr7V5Zh219UTedJm8tHVHWpe3w3dRfqoGJRgivw/6hnBzHvtCl
         ZB5Fzn0JrEwiewM7aTTv2vMruFUe6z3QFSOLzFDDPeqAmA9/JePmaa+9i8vzxeJGVO/U
         4Jv1e6gpqD1j4qevVcuWYHOAfjanCugwinMhUnUvZ2fZvt+pLjQkb/uIKRWZ1qZ3s3HA
         9k5qWGgim8v+bWiwntFNhAVMzSZxI/scHNpk58RFkCJNF9FMyzah7nG6k/qfXSpXJ4Qg
         ARfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WfBOKQ6YfV+bOowYEXO7+f3CsFRgD5WWO3dsN5dpEOA=;
        b=lAvi/2H59O8/eDsxL9aY2VVy0JSBDDaI6aOXEgHRlqWIhMcwhYWWSoMlVnfsp6O9w5
         dC1KxrScZud1/txVchZzQXSjZgeuLAp+K1H5y+OKrXSapqG4fyaPvffXs0RkzcTaSYk8
         O18hDrtHTcVCbQvr+3sUSl/kcRmXJLT9fBh+Kf6t+CFUTd+GJFVvyoXfcnAhwhYRI0iq
         o+k77h7p2z0gxQhbtFtJLYG+hLnAqfZEqz6zrcLfue8b44G3imGSEjyfwmRNSsqr9P6b
         CtXjyBcWE2okI3CrfILoLj2ZS344nQLlB9GpOPKm/2TcfN/LJwPhg4bwgFixAyWmOo3X
         gX1Q==
X-Gm-Message-State: AOAM532k7vaC2+MBjAAvR23w7jgmai6F4rj116dRfcW+HF+A36NBbt4p
        S7DcLZw2hb407cMelyRkZksm5ZDJ9CVGjsV9
X-Google-Smtp-Source: ABdhPJwzII2tqi6N/G+iQOywgxJe+pYSyHz1kQRpSXVxmuFc8UPDui3BPcDOWm+uIu+rVNUIPjUjOw==
X-Received: by 2002:a7b:c20b:: with SMTP id x11mr19266903wmi.150.1621851408551;
        Mon, 24 May 2021 03:16:48 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2090? ([2620:10d:c093:600::2:2b02])
        by smtp.gmail.com with ESMTPSA id c4sm11932896wrx.77.2021.05.24.03.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 03:16:48 -0700 (PDT)
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        Hillf Danton <hdanton@sina.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com" 
        <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210524071844.24085-1-qiang.zhang@windriver.com>
 <20210524082536.2032-1-hdanton@sina.com>
 <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdh?=
 =?UTF-8?Q?keup_wqe_in_hash_waitqueue?=
Message-ID: <916ad789-c996-258f-d3b7-b41d749618d8@gmail.com>
Date:   Mon, 24 May 2021 11:16:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/21 10:19 AM, Zhang, Qiang wrote:
[...]
>> Scratch scalp one inch off to work out how this is a cure given a) uaf makes
>> no sense without free and b) how io workers could survive
>> wait_for_completion(&wq->worker_done).
>>
>> If they could OTOH then this is not the pill for the leak in worker_refs.
> 
> Hello Pavel Begunkov, Hillf Danton
> 
> Sorry there is a problem with the calltrace described in my message. Please ignore this modification 

Haven't looked at the trace and description, but I do think
there is a problem it solves.

1) io_wait_on_hash() -> __add_wait_queue(&hash->wait, &wqe->wait);
2) (note: wqe is a worker) wqe's workers exit dropping refs
3) refs are zero, free io-wq
4) @hash is shared, so other task/wq does wake_up(&wq->hash->wait);
5) it wakes freed wqe

step 4) is a bit more trickier than that, tl;dr;
wq3:worker1 	| locks bit1
wq1:worker2 	| waits bit1
wq2:worker1 	| waits bit1
wq1:worker3 	| waits bit1

wq3:worker1	| drop  bit1
wq1:worker2	| locks bit1
wq1:worker2	| completes all wq1 bit1 work items
wq1:worker2	| drop  bit1, exit and free io-wq

wq2:worker1	| locks bit1
wq1 		| free complete
wq2:worker1	| drops bit1
wq1:worker3 	| waked up, even though freed

Can be simplified, don't want to waste time on that

-- 
Pavel Begunkov
