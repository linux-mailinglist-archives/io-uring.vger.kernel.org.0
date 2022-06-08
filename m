Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61B5429BA
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbiFHIp1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 04:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiFHIog (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 04:44:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987115A776;
        Wed,  8 Jun 2022 01:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654675462; x=1686211462;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CWj70Ndahv6ITFdse9tZAg4WvoJpQZirpty4fhrEmng=;
  b=DNw6etCnx2dNycxcp4G8Ca78Cyg20EED+/xsl2mc0yWba8oZI2CEl39s
   FVYgSJvLSJdSQERZn9Az9+ItNvmQ3lxJr1dV8V8d4m5N7YzQKzok24PnB
   b4xP8OJsaBA+hsnAcoU9zi2V7sqfDtQ3ipJ2NTcpo43DSKMRXTvoHIEK1
   nuSP8HOwhKYctc6id29aA/F/wOTMHMnnffBFYOLPp50e7dBYtzjUJtkLP
   6DuaoVU43T1UOwS+9G/eYZXYH+vNDzY5RXpvLiDPupxYZE6nVBY6m3bb9
   pqwy1xmVjVk80oxYtpqfuUahSj+rqplK+IqFRYkSjhPIAGZguXJE4kwHL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="277986485"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="277986485"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:01:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="584724477"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 01:00:57 -0700
Date:   Wed, 8 Jun 2022 16:00:54 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, ying.huang@intel.com,
        feng.tang@intel.com, zhengjun.xing@linux.intel.com,
        fengwei.yin@intel.com, guobing.chen@intel.com,
        ming.a.chen@intel.com, frank.du@intel.com, Shuhua.Fan@intel.com,
        wangyang.guo@intel.com, Wenhuan.Huang@intel.com,
        jessica.ji@intel.com, shan.kang@intel.com, guangli.li@intel.com,
        tiejun.li@intel.com, yu.ma@intel.com, dapeng1.mi@intel.com,
        jiebin.sun@intel.com, gengxin.xie@intel.com, fan.zhao@intel.com
Subject: Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Message-ID: <20220608080054.GB22428@xsang-OptiPlex-9020>
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens Axboe,

On Fri, May 27, 2022 at 07:50:27AM -0600, Jens Axboe wrote:
> On 5/27/22 3:24 AM, kernel test robot wrote:
> > 
> > 
> > Greeting,
> > 
> > FYI, we noticed a -10.2% regression of phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s due to commit:
> > 
> > 
> > commit: 584b0180f0f4d67d7145950fe68c625f06c88b10 ("io_uring: move read/write file prep state into actual opcode handler")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > in testcase: phoronix-test-suite
> > on test machine: 96 threads 2 sockets Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 512G memory
> > with following parameters:
> > 
> > 	test: fio-1.14.1
> > 	option_a: Sequential Write
> > 	option_b: IO_uring
> > 	option_c: Yes
> > 	option_d: Yes
> > 	option_e: 1MB
> > 	option_f: Default Test Directory
> > 	cpufreq_governor: performance
> > 	ucode: 0x500320a
> > 
> > test-description: The Phoronix Test Suite is the most comprehensive testing and benchmarking platform available that provides an extensible framework for which new tests can be easily added.
> > test-url: http://www.phoronix-test-suite.com/
> 
> I'm a bit skeptical on this, but I'd like to try and run the test case.
> Since it's just a fio test case, why can't I find it somewhere? Seems
> very convoluted to have to setup lkp-tests just for this. Besides, I
> tried, but it doesn't work on aarch64...

we just follow doc on http://www.phoronix-test-suite.com/ to run tests in PTS
framework, so you don't need to care about lkp-tests.

and for this fio test, the parameters we used just as:
	test: fio-1.14.1
	option_a: Sequential Write
	option_b: IO_uring
	option_c: Yes
	option_d: Yes
	option_e: 1MB
	option_f: Default Test Directory


and yeah, we most focus on x86_64 and don't support lkp-tests to run on
aarch64...


if you have some idea that we could run other tests, could you let us know?
it will be great pleasure to run more tests to check for us if we can support.

Thanks a lot!

> 
> -- 
> Jens Axboe
> 
