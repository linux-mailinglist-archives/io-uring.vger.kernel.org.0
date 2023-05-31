Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DCA718A01
	for <lists+io-uring@lfdr.de>; Wed, 31 May 2023 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjEaTSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 May 2023 15:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjEaTSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 May 2023 15:18:49 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F956136;
        Wed, 31 May 2023 12:18:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 720523200488;
        Wed, 31 May 2023 15:18:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 31 May 2023 15:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1685560724; x=1685647124; bh=xq
        8RBedQ3sB9Mo7GT+EN0dCesgPG9Vj9tJJoe1zny1M=; b=jh1xX9pfANE0yprjLp
        srqy1gT3wr5+d3aHfrMtNPGTYcznlT6YpnWn/T98iH28pstLVRXohapRxmqr2zQC
        drqD4UOcrLHSzoS/c8Lnqs8aXOPmEUtS5ZQDL4Z9HaTzl/orvXHy62UHdVCn/Nnp
        LFOyW/jRnjnwpmFUpisI54AvWoc37ssYhroFnL1QDTFQgpEyQ7mQrzWLBF7oux1y
        u1Vn6fKdYHEfcQ/plK/CDx/FqLOSLgZ62BjSo4H+5OWr86B3WDLz9x5fr6bFqHJb
        jbM2eSYXWBSc/RJdlyRB3iLpoJOhQRjwQPHgQUiBdUAR5gmI+EeLHqtxGGTIKQ/G
        6EWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1685560724; x=1685647124; bh=xq8RBedQ3sB9M
        o7GT+EN0dCesgPG9Vj9tJJoe1zny1M=; b=S8cPPK+jpvT50eFsxGvJHTlZ4w2y4
        xMk+3qLKeJZ97VjNLxXIIqxiVkt6jMAb6o6nb01ZuA2onXly+Mz1KAuOwFqK5oRX
        OaJ5mRrQ2MIE+tGycvUXorya30aTch9PpUlSOnzr9QV2MDtGhu5A0pmTHrD6LieB
        PQZCQq02G11ofL9+31AUTnh/DDM5zB6AeCGUVh0xhCNkRDzHY3jeNQD3M8pIU5T0
        lXoDd2n0uuuIT00CDBd7webh1ZYFXwU6zp20gR9pLhFKmzLciT5xvUVAnR9mqpXQ
        zoSffHvA43W6Ioz+qVXCgtUIJ64g6I4ccsZDPCW6kITbHbc6wZX2P1cpA==
X-ME-Sender: <xms:k513ZLgkuKU0dkiSY95VneVKYY4PqcOk1G8ZuZDYiIU_GgowpMM9oA>
    <xme:k513ZIAO-7HVzKOM0L6qGdWFELd1ebnMGJ-pO1DatVAVbMrGxQ7kqURdq7yk4Do1n
    gYinalwuiqIe8kJg0g>
X-ME-Received: <xmr:k513ZLGETKyA5DLs3Zv9eLuY8v2ENz3G8_xFO2I2eo-Um38q5DOhqb9bt8GiKUIzCJf6ZVwbDZyXHBKGIFfk4lCA0zU7-jlCfDHiqDOZMMcn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekledgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfhgfhffvvefuffgjkfggtgesth
    dtredttdertdenucfhrhhomhepufhtvghfrghnucftohgvshgthhcuoehshhhrseguvghv
    khgvrhhnvghlrdhioheqnecuggftrfgrthhtvghrnhephffgjeevudduhedvudevgfduvd
    fffefghfeiuedufeduhffhieejfeejffehledvnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:k513ZITx2jGfQBnoKfqtrqTmVHYJGe8Et5ujGK-yePLmI9rTgs5i0g>
    <xmx:k513ZIwxKUlkk7FBNvpyDKnVICU5X55QrHLnWTTW8M-B-EFRSEgsjg>
    <xmx:k513ZO58BL92IT8Ww5Qf5s8sURqVYnyOaGTS-CUn0JZE9HUFrgEEiA>
    <xmx:lJ13ZHrrmh3PcA_FwN3bD9GI8Y2RSIBoalztSGx6AheQ8b0l54s0ig>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 31 May 2023 15:18:42 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-2-shr@devkernel.io>
 <20230531103224.17a462cc@kernel.org>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Date:   Wed, 31 May 2023 12:16:50 -0700
In-reply-to: <20230531103224.17a462cc@kernel.org>
Message-ID: <qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 18 May 2023 14:17:45 -0700 Stefan Roesch wrote:
>> -	napi = napi_by_id(napi_id);
>> -	if (!napi)
>> +	ctx.napi = napi_by_id(napi_id);
>> +	if (!ctx.napi)
>>  		goto out;
>>
>>  	preempt_disable();
>
> This will conflict with:
>
>     https://git.kernel.org/netdev/net-next/c/c857946a4e26
>
> :( Not sure what to do about it..
>
> Maybe we can merge a simpler version to unblock io-uring (just add
> need_resched() to your loop_end callback and you'll get the same
> behavior). Refactor in net-next in parallel. Then once trees converge
> do simple a cleanup and call the _rcu version?

Jakub, I can certainly call need_resched() in the loop_end callback, but
isn't there a potential race? need_resched() in the loop_end callback
might not return true, but the need_resched() call in napi_busy_poll
does?
