Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB0738E3CE
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 12:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEXKUd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 06:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhEXKUc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 06:20:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0B3C061574;
        Mon, 24 May 2021 03:19:04 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f20-20020a05600c4e94b0290181f6edda88so4223084wmq.2;
        Mon, 24 May 2021 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VnjZn5/nKzc6q673Td0aqLSIzRDB2omX+z2Bmi3TRsc=;
        b=GHGFlMc/JUXf4L0zKi1D4G7C0Ipa7Hpofg4xWnxA5FYX2niIXoD1+45dQ8n9Igb93G
         luyZOhsvf5U/Tj1MtZNWLJZ5BVabjEJ/rLPlpzxp0fcJBnQDso6xnt4AOSXq0lrmCD5T
         oiBfYAiM8bmdUp9n/ZNwiAdS+zAWa+FjFfeI6Gp5YQ/9m48VIhduy6lIdHG1oiTbp3P5
         27Yp/ZY3/asOWLk6VVY8s2TAWGIegtIruHoEixGArt6psyF6fc8Pw+1iGDlZj6ZS/PjC
         Vmm7Rc3tWUfU2ARLtHHJbLx5Bh0oFPUrfbv2CyEdIWeMJK8wbLZmwGOlYWkHbQaSDIBX
         06Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnjZn5/nKzc6q673Td0aqLSIzRDB2omX+z2Bmi3TRsc=;
        b=gU1n8fiA2F/2mmedNME6wiyyZSeJguhv5qBGTSlpOURYVuA6ovmUDRP89CRXwiJNIK
         DOyUthISeFaQL0BiQV/GGWYuqnFar8soUz3ZUY4/QA1FvkpvKksaBNlyAxSmbc7RKUXm
         ltsRRvdnI2zPMiCVTNr4Mj+FdWikH/7XwzH4pUul/8gliPvN9fQglRgvxj2EgZVy0Eqz
         /5VZs+U2+b8z3BBcG+7F0XN0Gn+bm1x/0/ro5LhLqTtgxu3wolTApoxpx6qkxASIJWTM
         Q9XIlg8Dr3Ui8PkLC0nvOXilrp402yhh1ANSC/5eSwInofmYM09APmjs8vp4SEQDUMqG
         fIEQ==
X-Gm-Message-State: AOAM530Q2KUbgVZ6xJ6ihUGSDstXhQsDLKtBEz4A97bbKppeuSm0DlB2
        /2p//737UzgFOy5gKpcyGbBpPSps4d+CDr/j
X-Google-Smtp-Source: ABdhPJzwVsC2AFdDFgjvgf86nH7odhYUhf2InB1KrGcSM/3SBVwbz4bulsn2gXx5o2COUZrJeWNWLA==
X-Received: by 2002:a1c:14e:: with SMTP id 75mr2135146wmb.89.1621851542400;
        Mon, 24 May 2021 03:19:02 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2090? ([2620:10d:c093:600::2:2b02])
        by smtp.gmail.com with ESMTPSA id x2sm7248430wmj.3.2021.05.24.03.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 03:19:02 -0700 (PDT)
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogW1BBVENIXSBpby13cTogRml4IFVBRiB3aGVuIHdh?=
 =?UTF-8?Q?keup_wqe_in_hash_waitqueue?=
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
Message-ID: <900206b7-cf22-8248-1130-89c8f9d5539b@gmail.com>
Date:   Mon, 24 May 2021 11:18:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/21 10:19 AM, Zhang, Qiang wrote:
> On Mon, 24 May 2021 15:18:44 +0800
>> From: Zqiang <qiang.zhang@windriver.com>
>>
>> The syzbot report a UAF when iou-wrk accessing wqe of the hash
>> waitqueue. in the case of sharing a hash waitqueue between two
>> io-wq, when one of the io-wq is destroyed, all iou-wrk in this
>> io-wq are awakened, all wqe belonging to this io-wq are removed
>> from hash waitqueue, after that, all iou-wrk belonging to this
>> io-wq begin running, suppose following scenarios, wqe[0] and wqe[1]
>> belong to this io-wq, and these work has same hash value.

Zhang, btw check your mail encoding, should some plain unicode


-- 
Pavel Begunkov
