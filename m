Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122032AF58A
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 16:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgKKPzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 10:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgKKPzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 10:55:33 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39099C0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 07:55:33 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r12so2777497iot.4
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 07:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vyVaue9DKw34aslpFd5N387h5+z4grH1P6vcmgJog44=;
        b=fdr+V95jvZKbyyyVluBRTjqDe9ZbXX5bZQovjruWmehpbRyOt6/p1CT1m0irfRH5PB
         pBHu0p0FWuf8+zF+16O+kON4xa3VZN9Af2uWaVkJM15oSOqKiWdGZyYJoFaapC4rRy1H
         gDIXkrrPxED+BGPDgez4nt5uiqa163fz3poPt7+HC+2HVZuwsTaljOWaihE8FOND/MU0
         s2jiVg0m35YBUV6ubsntb+Sbk7UDHgFozsjZADU+lE3t91CHpKNCnE1HCnVd6nFAUFu4
         z4fen8/hrhVCQC0r0vj4nMq8F7XNxZ4moXLiPBfZ8bSjEVrrhyem3kL+Y22AD+n6uqFS
         mUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vyVaue9DKw34aslpFd5N387h5+z4grH1P6vcmgJog44=;
        b=GzlaCmW0UaLfC6m7zagQCkTox3IdMCwMiJAQp6/E2p2g9oAIjY4ny6WixYGtLgZyaX
         37iLt8jG+j3QWJ0BUprfKcEnoirVuue1PG1oa5haiWQzhrvh04SYzIlJnHoZ2+RtnaKV
         9V/TONmvEegR2HUeUF7+jhMHC8kUI600NHHyt3EaPv6XiwpoxiEUzZk+D03Boura2+B4
         VTK4EkmdsF59HmhiGks23lH0iVE5U2LJtGcrKVItduQWVB2RJJOVp9tfdv/14c5EMXkF
         qlarIVbPwdOMcL+IVOqDVnIecDQi3D4alPAFECBUjNTilcQPjes1edKMjJnuiIkOMW1K
         Na5g==
X-Gm-Message-State: AOAM532LImCbaKhEnlyaWODEbiQg0ooGxvhWasF4H0hhr9vR6G90jK9l
        pm/YTzG+SoT2XoF9zPjHeRpBNVlb3zLuDA==
X-Google-Smtp-Source: ABdhPJwmmVZIqcvvpUaL44moToOvB4vVs5XfU1nBZ/xf2Nau3awWIzmtmCewOK9lYvYwu+L/oCgk/w==
X-Received: by 2002:a6b:7702:: with SMTP id n2mr18252754iom.4.1605110132323;
        Wed, 11 Nov 2020 07:55:32 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q1sm1442590iot.48.2020.11.11.07.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 07:55:31 -0800 (PST)
Subject: Re: [bug report] io_uring: refactor io_sq_thread() handling
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <20201111113810.GA1248583@mwanda>
 <09eb9ff4-9680-c330-1904-5ffa391101db@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <480d4dd1-9f7d-5820-c15e-203cd5f0c8ea@kernel.dk>
Date:   Wed, 11 Nov 2020 08:55:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <09eb9ff4-9680-c330-1904-5ffa391101db@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/20 7:04 AM, Xiaoguang Wang wrote:
> hi,
> 
>> Hello Xiaoguang Wang,
>>
>> The patch e0c06f5ab2c5: "io_uring: refactor io_sq_thread() handling"
>> from Nov 3, 2020, leads to the following static checker warning:
>>
>> 	fs/io_uring.c:6939 io_sq_thread()
>> 	error: uninitialized symbol 'timeout'.
>>
>> fs/io_uring.c
>>    6883  static int io_sq_thread(void *data)
>>    6884  {
>>    6885          struct cgroup_subsys_state *cur_css = NULL;
>>    6886          struct files_struct *old_files = current->files;
>>    6887          struct nsproxy *old_nsproxy = current->nsproxy;
>>    6888          struct pid *old_thread_pid = current->thread_pid;
>>    6889          const struct cred *old_cred = NULL;
>>    6890          struct io_sq_data *sqd = data;
>>    6891          struct io_ring_ctx *ctx;
>>    6892          unsigned long timeout;
>>                  ^^^^^^^^^^^^^^^^^^^^^^
>>
>>    6893          DEFINE_WAIT(wait);
>>    6894
>>    6895          task_lock(current);
>>    6896          current->files = NULL;
>>    6897          current->nsproxy = NULL;
>>    6898          current->thread_pid = NULL;
>>    6899          task_unlock(current);
>>    6900
>>    6901          while (!kthread_should_stop()) {
>>    6902                  int ret;
>>    6903                  bool cap_entries, sqt_spin, needs_sched;
>>    6904
>>    6905                  /*
>>    6906                   * Any changes to the sqd lists are synchronized through the
>>    6907                   * kthread parking. This synchronizes the thread vs users,
>>    6908                   * the users are synchronized on the sqd->ctx_lock.
>>    6909                   */
>>    6910                  if (kthread_should_park())
>>    6911                          kthread_parkme();
>>    6912
>>    6913                  if (unlikely(!list_empty(&sqd->ctx_new_list))) {
>>    6914                          io_sqd_init_new(sqd);
>>    6915                          timeout = jiffies + sqd->sq_thread_idle;
>>                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> timeout not set on else path.
> Thanks for the report, but indeed I think it's not a bug. When io_sq_thread
> is created initially, it's not waken up to run, and once it's waken up to run,
> it will see that sqd->ctx_new_list is not empty, then timeout always can be
> initialized.

We should still clean it up and avoid both the checker tripping on on this,
and humans. It's not easy/possible to verify that it is sane.

-- 
Jens Axboe

