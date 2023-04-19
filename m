Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE086E83DE
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 23:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjDSVkI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 17:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDSVkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 17:40:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F74D1736
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 14:40:06 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b875d0027so85248b3a.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 14:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681940406; x=1684532406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZB8eTY6M3oiRedyQgfwIJCc4kKSXMHKsW02R7RxDv3Q=;
        b=d1r7398swJYsZ+wrA2NnvLLJESNHoK4twLvhd+h5uHZE7PyKI/51IzgmkHAgrm96t3
         wpZ6P1YArcMO5909+KEEi7BskNNXtONSa2zd7yNDDzZ4Y+Qvj8q+1sh/dKjOPiVe+d3y
         hxszklfwt1yg/7JeKNyJrrSUEGOU1BYOzImVH37RyjoDEs3uFbpm8QqYZNVWI2KOtRN9
         sMcl00Psve+2PIGuJu9r7EF34iU3pMTMiLRADhxGIe62ELMh+UIuRgCBQWH/FachcO6B
         bDIjWJUXCV6sRlfW7xTHEFgqf7QPNc7XX1IWX9VJlrXwOBvpqSNhg4XIyS/1QO0rLX++
         kacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681940406; x=1684532406;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB8eTY6M3oiRedyQgfwIJCc4kKSXMHKsW02R7RxDv3Q=;
        b=KZO522K4fW5Bz33GKHnDSwU+meTuxF/nco1N13zhed73dS4ijxktGX1TCchhQXNYW/
         FCGjcrVLagNd8c8SHar9AILtWThKa9SOB2OTDdhO2RtCgudU/fb/5uUtkt12amonHovs
         Inv6iRPt3p94WbcqPHSEkco5riyhFiK/wLTUqHZopVu8fMJdRMDkJzLLI852Yp5funQQ
         aH4O+WW6ZHgnlTfhpYULCQ5xvxHduSE1LJJR6nz19SGEI2RiblrMsxlf1BF1lBxWUewH
         icx/nFv081jYZ08lTQlgjhuVdwHauhndrMfNX92uxAZXNTFvXJivQR9fL9arwdWI1hlQ
         dNaw==
X-Gm-Message-State: AAQBX9f9C6u2Q+qYogib38nT2zl1H/e5u6+LNs0UPHJIaXfTAn/N35wC
        UZai5kDy4pN0IsoE5e5ANdCXmA==
X-Google-Smtp-Source: AKy350Zf411n/HMKw4bVqadJgpWvyBJv77sj8iNEmtP+64p1e+FJeBU480pFT3LS8bMMHH45LXyhLA==
X-Received: by 2002:a05:6a00:1c9e:b0:63d:344c:f123 with SMTP id y30-20020a056a001c9e00b0063d344cf123mr7557891pfw.1.1681940405950;
        Wed, 19 Apr 2023 14:40:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 23-20020aa79117000000b0062dd8809d6esm11375470pfh.150.2023.04.19.14.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 14:40:05 -0700 (PDT)
Message-ID: <45ec1616-e8fa-19e3-deae-78a40e6b2ffa@kernel.dk>
Date:   Wed, 19 Apr 2023 15:40:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring: Optimization of buffered random write
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, luhongfei <luhongfei@vivo.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        opensource.kernel@vivo.com
References: <20230419092233.56338-1-luhongfei@vivo.com>
 <202304200502.T4Waeqad-lkp@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <202304200502.T4Waeqad-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 3:30?PM, kernel test robot wrote:
> Hi luhongfei,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v6.3-rc7 next-20230418]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/luhongfei/io_uring-Optimization-of-buffered-random-write/20230419-172539
> patch link:    https://lore.kernel.org/r/20230419092233.56338-1-luhongfei%40vivo.com
> patch subject: [PATCH] io_uring: Optimization of buffered random write
> config: i386-randconfig-a012-20230417 (https://download.01.org/0day-ci/archive/20230420/202304200502.T4Waeqad-lkp@intel.com/config)
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/620dbcc5ab192992f08035fd9d271ffffb8ff043
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review luhongfei/io_uring-Optimization-of-buffered-random-write/20230419-172539
>         git checkout 620dbcc5ab192992f08035fd9d271ffffb8ff043
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202304200502.T4Waeqad-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> io_uring/io_uring.c:2091:25: error: no member named 'rw' in 'struct io_kiocb'
>            if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
>                              ~~~  ^
>    1 error generated.

The patch just can't work. Looks like it was forward ported on an older
kernel, but not even compiled on a recent kernel. There's no
req->rw.kiocb, hasn't been the case since 5.19. And you also can't do
layering violations like this, req->rw is rw.c private and cannot even
be used in io_uring.c.

-- 
Jens Axboe

