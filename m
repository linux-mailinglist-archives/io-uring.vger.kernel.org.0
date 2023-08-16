Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EDA77E9A4
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 21:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344662AbjHPT1l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 15:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345418AbjHPT13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 15:27:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B516C1FCE
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 12:27:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68824a0e747so969621b3a.1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 12:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692214047; x=1692818847;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2HUcpa3iMWGIi5p4N5dk0bMC9c1CU10lky57bGztfbY=;
        b=wmeIzXcsbc1dzPFU4qk1WMuM8mL1JHd9wxVQUUKjhcExFJPKF/fLtMZiXdWJvVXhBv
         WUQ5PPhcceIxBvoFrDZEx5WULwpIW6h6bGrKfV+/yN0q5YBfMUOD0Dq8jGUS7uqGlr6J
         rRjFafJVu+/1WfvbgOML3kf9JKqDpcVZXzAf74AO05rsKS8CdnL9ie58wNYuEN5TcSzO
         LiGpQA+nyAFYlC4XJHn7GqmdJ/RP92j7AlPqM1sSJ9JgDbqa96+2bBzwe0nsetVvRq0B
         8EYKA/DzGyjdN16s8GddC52GHzzT/0qLOrv57MzOkdhdkfuU+D5r545cGekmyZqbuuHk
         4ZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692214047; x=1692818847;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2HUcpa3iMWGIi5p4N5dk0bMC9c1CU10lky57bGztfbY=;
        b=MSFdGuwahvLtJpuoRTIK16qReE4+1TH5eVi1jOix8TN1Gf0h85IYPT6kRjzyQouFvl
         jueTn6gqjC/VyuBA2r9f7RTVCkZkYhJVDthzHDBf24L1FgjonstQpqnJvClPgRs7PBxD
         90KccZ6kiOyUfTRrS8Bvv5YKSW7ieizwa+56JWgnjEYNq/Ha2K3Olhc5Z+UkMAp4UxIc
         cNJZ0axt3rKAJtgWWg0uWC24LGpP4n9JjXej+laMC7hOk150v6ED7MEobJbVQhqeUc4K
         auW+Ixxk0ae/177rkuMLiroPzTZV4tSiSSuovLGoTTkBwMgwkFpTyfegxwVRGhg2TSI/
         E7yQ==
X-Gm-Message-State: AOJu0YxbNlHYl/AZUlgN/6Uo9qx3e0zHjCkUeFZmAMgeeKEsyX98D10X
        mKVYHLBPNkMJ8PFAvAEXpwr+Yw==
X-Google-Smtp-Source: AGHT+IF3E+Quu9/8CGPu4O3VVBBji7WwDT+aqYCrn3GMcbo7TAbieO74SQRqTNcu8Gktiq+b+N3DSg==
X-Received: by 2002:a05:6a00:a17:b0:687:95ad:d8dd with SMTP id p23-20020a056a000a1700b0068795add8ddmr3089223pfh.0.1692214046903;
        Wed, 16 Aug 2023 12:27:26 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x21-20020aa784d5000000b006889511ab14sm957268pfn.37.2023.08.16.12.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 12:27:26 -0700 (PDT)
Message-ID: <8a19b81a-10ed-4d65-9fbd-433af11e822f@kernel.dk>
Date:   Wed, 16 Aug 2023 13:27:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [io_uring] caec5ebe77:
 stress-ng.io-uring.ops_per_sec -33.1% regression
Content-Language: en-US
To:     "Yin, Fengwei" <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ying.huang@intel.com, feng.tang@intel.com
References: <202307060958.3594f22f-oliver.sang@intel.com>
 <80519d5f-e328-4ea4-a488-00209432d5d9@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <80519d5f-e328-4ea4-a488-00209432d5d9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 9:32 AM, Yin, Fengwei wrote:
> Hi Jens,
> 
> On 7/6/2023 3:29 PM, kernel test robot wrote:
>>
>>
>> Hello,
>>
>> kernel test robot noticed a -33.1% regression of stress-ng.io-uring.ops_per_sec on:
>>
>>
>> commit: caec5ebe77f97d948dcf46f07d622bda7f1f6dfd ("io_uring: rely solely on FMODE_NOWAIT")
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>
>>
>> NOTE:
>> one thing we want to mention is we reported
>> "[linux-next:master] [io_uring]  caec5ebe77: stress-ng.io-uring.ops_per_sec 32.5% improvement"
>> on
>> https://lore.kernel.org/all/202306061247.510feb23-oliver.sang@intel.com/
>> however, by further checking, we realized the test machine ran in abnormal
>> status at that time due to BIOS issue, which we finally fixed recently.
>> please just ignore that report upon linus-next/master.
>>
>>
>> testcase: stress-ng
>> test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
>> parameters:
>>
>> 	nr_threads: 100%
>> 	testtime: 60s
>> 	class: pts
>> 	test: io-uring
>> 	cpufreq_governor: performance
>>
>>
>> In addition to that, the commit also has significant impact on the following tests:
>>
>> +------------------+-------------------------------------------------------------------------------------------------+
>> | testcase: change | stress-ng: stress-ng.io-uring.ops_per_sec -1.3% regression                                      |
>> | test machine     | 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @ 3.00GHz (Cascade Lake) with 128G memory |
>> | test parameters  | class=pts                                                                                       |
>> |                  | cpufreq_governor=performance                                                                    |
>> |                  | nr_threads=100%                                                                                 |
>> |                  | test=io-uring                                                                                   |
>> |                  | testtime=60s                                                                                    |
>> +------------------+-------------------------------------------------------------------------------------------------+
>>
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202307060958.3594f22f-oliver.sang@intel.com
>>
>>
>> Details are as below:
>> -------------------------------------------------------------------------------------------------->
>>
>>
>> To reproduce:
>>
>>         git clone https://github.com/intel/lkp-tests.git
>>         cd lkp-tests
>>         sudo bin/lkp install job.yaml           # job file is attached in this email
>>         bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
>>         sudo bin/lkp run generated-yaml-file
>>
>>         # if come across any failure that blocks the test,
>>         # please remove ~/.lkp and /lkp dir to run from a clean state.
>>
>> =========================================================================================
>> class/compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>>   pts/gcc-12/performance/x86_64-rhel-8.3/100%/debian-11.1-x86_64-20220510.cgz/lkp-icl-2sp7/io-uring/stress-ng/60s
>>
>> commit: 
>>   e9833d8701 ("block: mark bdev files as FMODE_NOWAIT if underlying device supports it")
>>   caec5ebe77 ("io_uring: rely solely on FMODE_NOWAIT")
> About this regression, some findings in my side:
> - LKP use initrd to do stress-ng testing. That means the stress-ng is using the
>   file in initrd as test file.
> - The commit caec5ebe77 makes io_uring rely on FMODE_NOWAIT. But the tmpfs and
>   the file on initrd doesn't has that bit set. I suppose this is why we can see
>   this regression with LKP which is using initrd.
> 
>   I tried to let stress-ng.io_uring use the file on tmpfs and also can see
>   signifcient performance change with this commit.
> 
> - If apply following change based on commit caec5ebe77:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 7c426584e35a..e755697c773f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1765,6 +1765,17 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
>   */
>  static bool __io_file_supports_nowait(struct file *file, umode_t mode)
>  {
> +       if (S_ISREG(mode)) {
> +               struct block_device *bdev = file->f_inode->i_sb->s_bdev;
> +
> +               if (IS_ENABLED(CONFIG_BLOCK) &&
> +                               (!bdev || bdev_nowait(bdev)) &&
> +                               !io_is_uring_fops(file))
> +                       return true;
> +
> +               return false;
> +       }
> +
>         /* any ->read/write should understand O_NONBLOCK */
>         if (file->f_flags & O_NONBLOCK)
>                 return true;
> 
> The regression is gone with LKP.
> 
> - If apply following change based on commit caec5ebe77:
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e40a08c5c6d7..e9df664f0063 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3962,9 +3962,16 @@ const struct address_space_operations shmem_aops = {
>  };
>  EXPORT_SYMBOL(shmem_aops);
> 
> +static int shmem_file_open(struct inode *inode, struct file *filp)
> +{
> +       filp->f_mode |= FMODE_NOWAIT;
> +
> +       return generic_file_open(inode, filp);
> +}
> +
>  static const struct file_operations shmem_file_operations = {
>         .mmap           = shmem_mmap,
> -       .open           = generic_file_open,
> +       .open           = shmem_file_open,
>         .get_unmapped_area = shmem_get_unmapped_area,
>  #ifdef CONFIG_TMPFS
>         .llseek         = shmem_file_llseek,
> 
> The performance change when running stress-ng.io_uring with testing file
> in tmpfs is gone.
> 
> This is just the information FYI. I may miss something obviously here. Thanks.

This actually highlighted a problem with the old nowait logic, in that
it assumed !bdev would mean that nowait was fine. Looking at shmem, we
definitely need IOCB_NOWAIT handling in there to make that safe. So the
old code was buggy, and conversely, we can't also just add the
FMODE_NOWAIT without first making those improvements to shmem first.

Basically you'd want to ensure that the read_iter and write_iter paths
honor IOCB_NOWAIT. Once that's done, then FMODE_NOWAIT can indeed be set
in the open helper.

I might take a stab at this, but I'm out sick right now so don't think
it'd be cohesive if I did it right now.

-- 
Jens Axboe

