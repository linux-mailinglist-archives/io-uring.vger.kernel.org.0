Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A46A7D028E
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 21:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbjJSTcl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 15:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbjJSTck (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 15:32:40 -0400
Received: from out-209.mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6020CE8
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 12:32:39 -0700 (PDT)
Message-ID: <5faad529-4b70-7440-bcfc-087162188827@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697743957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePx8zze/iKgcUVaE3WeK6n9PQs3/kF7Mbd+rW2MW/3Y=;
        b=h/pvnlOwySKO5pMmiVRA+NB3dECa4wXSv0wYkgTaUmyGiJg7SnEwaDIqYMqCoK3v+20mNt
        fLnEauTnk/n2Ej0zJDZ/QXWVVzV+TfYJBKOFVU2f/+0kZ01Qpz9oHpZvBmwOCxyyin+LCp
        y/NttlXLfUkfVuPrL5ZMcRMN//zv6ro=
Date:   Thu, 19 Oct 2023 12:32:31 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v7 02/11] bpf: Add sockptr support for setsockopt
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, sdf@google.com,
        axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20231016134750.1381153-1-leitao@debian.org>
 <20231016134750.1381153-3-leitao@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20231016134750.1381153-3-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/23 6:47 AM, Breno Leitao wrote:
> The whole network stack uses sockptr, and while it doesn't move to
> something more modern, let's use sockptr in setsockptr BPF hooks, so, it
> could be used by other callers.
> 
> The main motivation for this change is to use it in the io_uring
> {g,s}etsockopt(), which will use a userspace pointer for *optval, but, a
> kernel value for optlen.

Acked-by: Martin KaFai Lau <martin.lau@kernel.org>

