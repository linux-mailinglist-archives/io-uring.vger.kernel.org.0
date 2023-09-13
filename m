Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBCB79F351
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjIMU5h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 16:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjIMU5g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 16:57:36 -0400
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Sep 2023 13:57:32 PDT
Received: from out-212.mta0.migadu.com (out-212.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8313F1BCC
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 13:57:32 -0700 (PDT)
Message-ID: <77405214-ae42-d58b-1d40-c639683a0cb1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694638098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwREo+am6jJ9+Xq8BZFdvke2FcjINYzH66vqtX+PkMY=;
        b=U6yP+KxVDbx6rtpw5f5CSR3ZoGvmldJXz0NCPIybsjJd+xyoTeZNMYs43/xZA2kbod2YuI
        iZHsYCL/aT/cgd5cQeknemK5X80ETTnnt0pK2hpUt00drdgkbSY60/xpzcdzZey3HW48B+
        pegXznmpHCLY9DTg87bF8nQnqSLSJc0=
Date:   Wed, 13 Sep 2023 13:48:09 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v6 8/8] selftests/bpf/sockopt: Add io_uring support
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        =?UTF-8?Q?Daniel_M=c3=bcller?= <deso@posteo.net>,
        Wang Yufen <wangyufen@huawei.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, krisman@suse.de,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20230913152744.2333228-1-leitao@debian.org>
 <20230913152744.2333228-9-leitao@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230913152744.2333228-9-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 8:27 AM, Breno Leitao wrote:
> Expand the BPF sockopt test to use also check for io_uring
> {g,s}etsockopt commands operations.
> 
> Create infrastructure to run io_uring tests using the mini_liburing
> helpers, so, the {g,s}etsockopt operation could either be called from
> system calls, or, via io_uring.
> 
> Add a 'use_io_uring' parameter to run_test(), to specify if the test
> should be run using io_uring if the parameter is set, or via the regular
> system calls if false.
> 
> Call *all* tests twice, using the regular io_uring path, and the new
> io_uring path.

The bpf CI failed to compile because of missing some newer enum: 
https://github.com/kernel-patches/bpf/actions/runs/6176703557/job/16766325932

An option is to copy the io_uring.h to tools/include/uapi/linux/.

