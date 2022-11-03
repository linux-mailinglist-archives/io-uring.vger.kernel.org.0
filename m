Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E28618B7E
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 23:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiKCW3M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 18:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbiKCW2n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 18:28:43 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC83A2229C;
        Thu,  3 Nov 2022 15:28:33 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 41F055C00B4;
        Thu,  3 Nov 2022 18:28:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 03 Nov 2022 18:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667514513; x=
        1667600913; bh=r4LfooITf3nrWSMnfNB3pZa38Xa+sKbxYRKtKCOW6Os=; b=A
        u4HkFYkD9K2yM9S4x/crbVwrJVxIdrWw9ItMx2xZbhoIoJo+3az8+kHU44lBfcbq
        f2P/+Ny8ECj/v3A4cDHWciPyESQcfmJw7ftog+l+vq+SYCNKv9EmQHSYd/yXEede
        Rae4/3rsSO2DR75rtReyG73/ndXBl2lMHfV+xJgn0RuqHwIrBZz8JhlOymaWgkUR
        qKcSOAnqrevgtByKiWKtZJ2GOOYlqRH2U5GqcAJiloUxIgkArfFf2PjFztNnt3MU
        lWYF9iEaXgovwmVTX9gkJ2PEwy1cMZdwR+QR4CqowP13Z+UJKoHYOQoM/qvJIpFY
        aagiJKUeNAU+q/XGabf6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1667514513; x=
        1667600913; bh=r4LfooITf3nrWSMnfNB3pZa38Xa+sKbxYRKtKCOW6Os=; b=p
        CZyMb7rEklW13nCcpezstiy2rXbINw+KSA6ZCd7xFX0wRcu6ii9eOxTm4nQVi0rC
        gc2ks2mIk4OFaaNmT+NPxbYK26EjxNJ3P/wnRW+9O/YmIGiFciGHLZx0H38Q6yOK
        rGPPpN9HCZGPBLSXlHmj5Ln1V+moUrIFkMDY7vfnUdOOZJ7d2a/TQ6ho3GleNa2e
        UBzThi1FiTJEUTNLaSATfLCAXTFgeuZxVrSxl0ovPlc+NeNy32b28pvRs08c3e00
        2EeUvdJq41X8yAvDqcyz9j15T4uRD8OeKEsvZZgRf68ah1lr0S4WBN48TvBK0GPJ
        iqeDhr0krhjuxdSQ1eGkw==
X-ME-Sender: <xms:kEBkY39WMiGnBd3ZsVQ3iIgfYljLBG_qzEkiojX6MtkFALPjlND8Zg>
    <xme:kEBkYzsKL4MXb-YTJUXhMe93QlyC15EM0ediuIFnA5UgZCxkKDmi7q4VejReCZ1FT
    cAAmg2F0QeUsGKY>
X-ME-Received: <xmr:kEBkY1C1_K1MQ6MBLGzCiGBMCBIrogjFPeEJXbZ86EpofDBkUx88kjdR4aUpjQhBNZyawVq2xRA3Y6JZbdoT6DtefeG8kehMtMrlFQ2KIfrlDQH778Cq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrudelgdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepuedukeehleekjeehvddvieeftdeuleeiiedu
    tdelhfevueeludfgleejveeitdfgnecuffhomhgrihhnpehgihhthhhusgdrtghomhenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgu
    rdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:kEBkYzd_IurK5rInNhTl-DBZWWqwiVMjVGKFQc1EFg3JxqPe6FXE6A>
    <xmx:kEBkY8NY8-NDih9R83qahSomueK64wiuD8Nv8W0dz4LZBPPsq9oqFw>
    <xmx:kEBkY1mZBh84Yt93DPWNC26zGqHGD3RZ1oDG7bskvGrMidQmFsGDDg>
    <xmx:kUBkYzeZK2JT8WtCN28f7wOTs6sQP1FH53QY73otzSnqaENChHSUhw>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Nov 2022 18:28:31 -0400 (EDT)
Message-ID: <712cd802-f3bb-9840-e334-385cd42325f2@fastmail.fm>
Date:   Thu, 3 Nov 2022 23:28:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH 4/4] ublk_drv: support splice based read/write zero
 copy
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-5-ming.lei@redhat.com>
Content-Language: en-US
From:   Bernd Schubert <bernd.schubert@fastmail.fm>
In-Reply-To: <20221103085004.1029763-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/3/22 09:50, Ming Lei wrote:
> Pass ublk block IO request pages to kernel backend IO handling code via
> pipe, and request page copy can be avoided. So far, the existed
> pipe/splice mechanism works for handling write request only.
> 
> The initial idea of using splice for zero copy is from Miklos and Stefan.
> 
> Read request's zero copy requires pipe's change to allow one read end to
> produce buffers for another read end to consume. The added SPLICE_F_READ_TO_READ
> flag is for supporting this feature.
> 
> READ is handled by sending IORING_OP_SPLICE with SPLICE_F_DIRECT |
> SPLICE_F_READ_TO_READ. WRITE is handled by sending IORING_OP_SPLICE with
> SPLICE_F_DIRECT. Kernel internal pipe is used for simplifying userspace,
> meantime potential info leak could be avoided.


Sorry to ask, do you have an ublk branch that gives an example how to 
use this?

I still have several things to fix in my branches, but I got basic fuse 
uring with copies working. Adding back splice would be next after 
posting rfc patches. My initial assumption was that I needed to 
duplicate everything splice does into the fuse .uring_cmd handler - 
obviously there is a better way with your patches.

This week I have a few days off, by end of next week or the week after I 
might have patches in an rfc state (one thing I'm going to ask about is 
how do I know what is the next CQE in the kernel handler - ublk does 
this with tags through mq, but I don't understand yet where the tag is 
increased and what the relation between tag and right CQE order is).

This got modeled a bit after ublk, but then diverged a bit.

https://github.com/aakefbs/linux/tree/fuse-uring
https://github.com/aakefbs/libfuse/tree/uring

(Again, the branches are not ready by any means for review yet).


Thanks,
Bernd
