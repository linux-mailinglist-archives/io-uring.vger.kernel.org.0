Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050D17D029F
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 21:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346334AbjJSTis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 15:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346036AbjJSTir (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 15:38:47 -0400
X-Greylist: delayed 833 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Oct 2023 12:38:44 PDT
Received: from out-203.mta1.migadu.com (out-203.mta1.migadu.com [IPv6:2001:41d0:203:375::cb])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F53D11B
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 12:38:44 -0700 (PDT)
Message-ID: <45656c55-3b36-e5f1-e391-fcdf3b7894e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697744322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdtap++lMZMR+npoayI3yJj/d7NXDRQud4t4dlixIKc=;
        b=KoAjOWrgYuvMBCnvtBDFwNWO8ZD33nPPs9iWlNLqybcahwjCcVTJc5AVHcEiOIroK1ljdK
        Ohq4ZJcXM/7eiRAqDVl3mr6JTHXZnJJJlrIcuXuZqyUB9NrqZ//UczaWu0sWo5py1I1k+N
        Lv689zCHO651BaHSRJ6lWs1cZxrWmTU=
Date:   Thu, 19 Oct 2023 12:38:37 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v7 03/11] net/socket: Break down __sys_setsockopt
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, sdf@google.com,
        axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20231016134750.1381153-1-leitao@debian.org>
 <20231016134750.1381153-4-leitao@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20231016134750.1381153-4-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/23 6:47 AM, Breno Leitao wrote:
> Split __sys_setsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_setsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.
> 
> do_sock_setsockopt() will be called by io_uring setsockopt() command
> operation in the following patch.

Acked-by: Martin KaFai Lau <martin.lau@kernel.org>

