Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4A792A57
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351623AbjIEQfB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 12:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354269AbjIEK3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 06:29:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CF4DB;
        Tue,  5 Sep 2023 03:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693909773; x=1725445773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bn7q6Tcu2HMXKbL23eq+DAUGqdWll8RQjB5RohTItbQ=;
  b=DBwRdMJHpj03uJQj0+iTo1UjRzTehrF2TdXkkZwBgCmNPq7QQlAOwjnK
   96+1HlG1roViquYLVDSl7anWSlvThXk2812zJuoaaDgE5rtk5GkAU7FV9
   xZYPcGbG5xDc5kbOycAbDAp71dR+qE3Xk/q3bqMwnvYJly13Vj8wluko1
   +feOadG4zR2ICWaYwiRmJd50fq/NE8F+p8IwVJvZACZWEO3ZetgrTSNHL
   nXb7cU42Vy0njPI66ur5tlI1WJ/BJVsgC2szOP12amG6asV3SvBD5vKM+
   rX7TYwgB/7KJKjt246fxo9ErtP9gVD81z7J2kNN1liSRVq+1mjNkHgvOr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="356254681"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="356254681"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 03:29:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="734605190"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="734605190"
Received: from unknown (HELO smile.fi.intel.com) ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 03:29:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qdTJC-006efP-1u;
        Tue, 05 Sep 2023 13:29:22 +0300
Date:   Tue, 5 Sep 2023 13:29:22 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Xin Long <lucien.xin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v4 04/10] net/socket: Break down __sys_getsockopt
Message-ID: <ZPcDAk81DAqevy43@smile.fi.intel.com>
References: <20230904162504.1356068-1-leitao@debian.org>
 <20230904162504.1356068-5-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904162504.1356068-5-leitao@debian.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 04, 2023 at 09:24:57AM -0700, Breno Leitao wrote:
> Split __sys_getsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_getsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.
> 
> do_sock_getsockopt() will be called by io_uring getsockopt() command
> operation in the following patch.
> 
> The same was done for the setsockopt pair.

...

> +	ops = READ_ONCE(sock->ops);
> +	if (level == SOL_SOCKET) {
> +		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
> +	} else if (unlikely(!ops->getsockopt)) {
> +		err = -EOPNOTSUPP;
> +	} else {
> +		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
> +			      "Invalid argument type"))
> +			return -EOPNOTSUPP;
> +
> +		err = ops->getsockopt(sock, level, optname, optval.user,
> +				      optlen.user);
> +	}

Can be written as

	} else if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
			     "Invalid argument type"))
		return -EOPNOTSUPP;
	} else {
		err = ops->getsockopt(sock, level, optname, optval.user,
				      optlen.user);
	}

With that done, the {} are not needed anymore.

> +	if (!compat) {

	if (compat)
		return err;

> +		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);

> +		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
> +						     optval, optlen, max_optlen,
> +						     err);

	return ... ?

> +	}
> +
> +	return err;
> +}

-- 
With Best Regards,
Andy Shevchenko


