Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181D65AB4C2
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiIBPMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbiIBPMV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:12:21 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6822CF8ECC
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 07:43:11 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e7so1245417ilc.5
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 07:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ws9YWy4apxqkLEPt6+StyblROxOsHkHhiKiz1m5qmvk=;
        b=EEVcmPDdNJF6xvqyHy1jfpfU+XoaG+rQ5FWCVuStvjjIvA6RETZobGKU2Zx6Revyps
         NsNDYTqVUh5OHjNTYdiryHRD5UU8sai3DCKdHWIUid+kJAmDdihoaEcwhbeILNO5q6Ds
         lb41K9aQ/sc13aUji6tNKeuMMF0607E0Foinxp8c5wpGHNJ+tVEzRDi8jpDfJSPi+aEq
         LdjmP//n9xbjZ987vibQOEwEKEc7wzWyBGeYNQ3VSVaTTKs9Rer/ODZf3EKnIAJCwkOb
         ZUwKKqW1QYSB8X9s0mfsiXMgjGO977Q0tTMirwQdgR/6BCUb1PxpTeVEJU7StS3M3JvT
         uZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ws9YWy4apxqkLEPt6+StyblROxOsHkHhiKiz1m5qmvk=;
        b=BrCg1Q3hORqgth/xuBpJ9vJ63uyMXn/ArGYQu1HN/C8MZVSQtX3f0ZwLQCCQGvdjYl
         hvjqENBxWwc9vuo2DthSM1AK5s4vR60mz7bGYw0sn7Mb8GCiVcleyJt8lbJelTTjJbIo
         EZJjYTH1YZf0inzBlBtwVNaix1HREs9rVJLjp8o09mY/2fiIZojbQVF7la/6KFyFO7gV
         3+WndffcIvniY3quwaPgUqmYugXl/H35i8fGEnm98U/gspp8qxlw6QhJAfUo0plUCHPA
         u490wlMdzmgL/Z4jW4c9AKu9YWAyYvd8wOCnbO/mjoOZxRpJljkdoJo5PjKznW2N3kJa
         RZgA==
X-Gm-Message-State: ACgBeo2Wp5BBgTiX9BiOVOxkLEd0j+PuCDCGIfHa0w9ai4oyyoFm570S
        16pQsgceE3m9otuWZTXu++UhUg==
X-Google-Smtp-Source: AA6agR6/bSHK6C+HTDcubc+uptJCtHyAiwJyoOqxPEqEZazWWcc77QH+ZunUy47BdHTIQvtfzCnTvQ==
X-Received: by 2002:a05:6e02:180f:b0:2de:813b:4e22 with SMTP id a15-20020a056e02180f00b002de813b4e22mr18547026ilv.313.1662129790698;
        Fri, 02 Sep 2022 07:43:10 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i14-20020a056e02054e00b002eadc9015f4sm893466ils.37.2022.09.02.07.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 07:43:10 -0700 (PDT)
Message-ID: <4ad5f8f7-9484-455a-77cd-d1c8a0dbcc3c@kernel.dk>
Date:   Fri, 2 Sep 2022 08:43:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v1 09/10] btrfs: make balance_dirty_pages nowait
 compatible
To:     kernel test robot <lkp@intel.com>, Stefan Roesch <shr@fb.com>,
        kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, josef@toxicpanda.com
References: <20220901225849.42898-10-shr@fb.com>
 <202209022236.e41DKuIt-lkp@intel.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <202209022236.e41DKuIt-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 8:34 AM, kernel test robot wrote:
> Hi Stefan,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on b90cb1053190353cc30f0fef0ef1f378ccc063c5]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
> base:   b90cb1053190353cc30f0fef0ef1f378ccc063c5
> config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220902/202209022236.e41DKuIt-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
>         git checkout b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
>>> ERROR: modpost: "balance_dirty_pages_ratelimited_flags" [fs/btrfs/btrfs.ko] undefined!

Stefan, we need an EXPORT_SYMBOL_GPL() on
balance_dirty_pages_ratelimited_flags() since it can now be used in a
modular fashion.

-- 
Jens Axboe
