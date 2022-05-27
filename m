Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA95553638B
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 15:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346092AbiE0Nud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbiE0Nuc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 09:50:32 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7E018358
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 06:50:31 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id q3so2875903ilt.9
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 06:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q4HlnP4M3KnRD2xQ+3g55EAyPzM5QsgR4RqaiwyAk1A=;
        b=Zsb9cEvreybbucDkNAONb+JKPAYw0lVzUav+MMbR6lOumdV74bMWuEyUxWDRZ8LYUk
         S/l/5LAYWqOO88JZlNJlDIrpucEzX39HWnSB771muMIVK4U3FYMhcWL9QMRMsMPXcTvn
         qhGMbs49nltl0iKMV+9eQp1xBJwLUYzGes3PkzPy2IdCthjIqaM5im5e0GyKVnnKmUAT
         oGCZDzfDb7CtDx2wZO2ezLCy61nT+G+K67Rz2YnJ44JTWH9zAuJ1DP8cNnHv4mxsFbon
         t4n64Al/RHZ3rxkZIaPSVfrks5u/juAFmHUhJDOEodEqrB0BbWOJrAW1MLL1c8wysVAU
         0ewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q4HlnP4M3KnRD2xQ+3g55EAyPzM5QsgR4RqaiwyAk1A=;
        b=DiPvAsogupXNVr57Ef33SAlAJ8iWrB6Nwl+IWROBEUrBVlcPOWqI3oUaZcAqseaiOc
         BkvTbS3+ABhdT70oBTq+3/2FUa2pDtSxkQsBVn0WBLAffJfEtHtAoaXr6VAiuUjEkq+9
         ThM2sI+IV+lpHO9MirzGLoErZPxLSsB1TyV7f/nMA03kqigVHaLDpAsef7zi3ngZ5UMV
         X02Y+atk2Y00T4u9bHq22UFreL1kQHgcstiKtIqVNK8GASsi7WntbF9sxE33yymJEB7Q
         +iA/ZyniwE2Lqx5iPG+NrlsPp5vGv5n3bokDgRcXtokyKZN+ZoIZYSSZ/V6FBJ5+cwc5
         OSEQ==
X-Gm-Message-State: AOAM531MnSLGlWdcXiRDdcJRxII3IJx1Om+FgFw0Q95Hcva3BHX7jvhO
        cSzAv7pRClRZAMVEs+jlNIxEkA==
X-Google-Smtp-Source: ABdhPJzflBDP+8KeLHSwwPSvMDerBpNFXjto1MRZdAl991s8Idyks4+WKMogwIQgTljrfXPNPfD/cw==
X-Received: by 2002:a05:6e02:1a83:b0:2d1:bb9a:bade with SMTP id k3-20020a056e021a8300b002d1bb9abademr11282606ilv.189.1653659430312;
        Fri, 27 May 2022 06:50:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a4-20020a056e0208a400b002d1a5afa79bsm1281521ilt.86.2022.05.27.06.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 06:50:29 -0700 (PDT)
Message-ID: <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
Date:   Fri, 27 May 2022 07:50:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        fengwei.yin@intel.com, guobing.chen@intel.com,
        ming.a.chen@intel.com, frank.du@intel.com, Shuhua.Fan@intel.com,
        wangyang.guo@intel.com, Wenhuan.Huang@intel.com,
        jessica.ji@intel.com, shan.kang@intel.com, guangli.li@intel.com,
        tiejun.li@intel.com, yu.ma@intel.com, dapeng1.mi@intel.com,
        jiebin.sun@intel.com, gengxin.xie@intel.com, fan.zhao@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527092432.GE11731@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 3:24 AM, kernel test robot wrote:
> 
> 
> Greeting,
> 
> FYI, we noticed a -10.2% regression of phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s due to commit:
> 
> 
> commit: 584b0180f0f4d67d7145950fe68c625f06c88b10 ("io_uring: move read/write file prep state into actual opcode handler")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> in testcase: phoronix-test-suite
> on test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 512G memory
> with following parameters:
> 
> 	test: fio-1.14.1
> 	option_a: Sequential Write
> 	option_b: IO_uring
> 	option_c: Yes
> 	option_d: Yes
> 	option_e: 1MB
> 	option_f: Default Test Directory
> 	cpufreq_governor: performance
> 	ucode: 0x500320a
> 
> test-description: The Phoronix Test Suite is the most comprehensive testing and benchmarking platform available that provides an extensible framework for which new tests can be easily added.
> test-url: http://www.phoronix-test-suite.com/

I'm a bit skeptical on this, but I'd like to try and run the test case.
Since it's just a fio test case, why can't I find it somewhere? Seems
very convoluted to have to setup lkp-tests just for this. Besides, I
tried, but it doesn't work on aarch64...

-- 
Jens Axboe

