Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134E36F0B3C
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 19:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbjD0Rpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 13:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244178AbjD0Rpe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 13:45:34 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA1249C4
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 10:45:10 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 737F35C00D3;
        Thu, 27 Apr 2023 13:45:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 27 Apr 2023 13:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1682617507; x=1682703907; bh=TG
        lI3W+NADHtX80jzQq4o9Nj8WP+sezCa7SDCHDM2KY=; b=XK+IhEk8oXHdzx9/6L
        8wQB+wzgjpYMEIfvKl9zwwQhzd0TNjDtCjB9M17yoSBgwzRbGK70cF50ik2g/51m
        konChDZjpFbMOszDF1jFcN5RAowr86sAojVTiTJ+CHHEp2xGzXyFTxkPkUwf048s
        H1CfwF97tB47rymIGhVXPJvjMwIbXVqYJqccoS7m/a98TSUNu5DaDbNWvsiDZX+K
        MsiecOz3ftylsZC1cwGuhHCKSN6jeVcm18noLRhrc5wD1XSCYJ4cJAYIh/XvkMH5
        G3ntTCByYaZHuPglb0QSPRdUXoDP6Xdmzue794yYMTKI0adBBvv1CAlvu9E7hJak
        RRQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682617507; x=1682703907; bh=TGlI3W+NADHtX
        80jzQq4o9Nj8WP+sezCa7SDCHDM2KY=; b=Wq92JLAJEsqqA6T0+zM0Lx/IZyaev
        uHJ6CqS4DYRn9mYj5oukw0DwPm0G1RZOHW1uhYAJKc+nDppV3jN+syo/ZMtr/cPJ
        GiLPhFhnpWpDeWW2AqK+2uH1bZ4MEFIWNAmpVq3nL7pDg/8SB63Ud75sbqNzaLnL
        qS3UJuyXWQm+HBTVvBdAtZlamskBaRH2xr8yTiLu3vgVdFagrofCOR/2yCnDm37N
        P+1SOEVTdX17m2kr6C3hpVyWtpUtz1Bw6n3yiV3CvpxggoljKbUj8Ta6WnTYHmW4
        RCXNKsODMBUoovcjGwHjwPKfKS5MJbdnHDlA/gEA//dmJPJmxzhD/9Iqg==
X-ME-Sender: <xms:o7RKZI59gYjPg6h1sDx4mKHQ7jloDy40SRfJTTBI37wdS3B7t7b17A>
    <xme:o7RKZJ4lzqC2RCTYFTKTojTymOkHbrC8la7picHbZXlJihtPKYHZ3gpe2FvMDjk2u
    vDwo7wIWF9T3Saen3c>
X-ME-Received: <xmr:o7RKZHdQmla8OocjU6Dnudrd-cAT7E7alO1uFU3coRnkOU0tTiK8_-sXhprq9ON3vFokmyr82TXXlkfZBneqCk16cvUNwvnO2fGqOPoURSU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduiedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:o7RKZNKYlihAFQ1vGmUjX6zRaaNw_K_u1UBnr6iYF_6VkHDnAsE9EQ>
    <xmx:o7RKZMKBR8_oax8fzhMv0ABz5OffE3mAMjscm19hGeq0pzQlVdA4lw>
    <xmx:o7RKZOwnxdtomMZx97BWkvdfZfPyuBLnHKgzuLPbuXGhsQg6HoZr0A>
    <xmx:o7RKZBGG9G5_XSIKnHfbQ4K-T1SFSagtv5UQWq2fU7cWhJFesEEYMg>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Apr 2023 13:45:06 -0400 (EDT)
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
 <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Date:   Thu, 27 Apr 2023 10:44:49 -0700
In-reply-to: <dbf750fb-5a7b-8d10-d71b-4def3441e821@kernel.dk>
Message-ID: <qvqwttx19q3i.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 4/26/23 7:41?PM, Jens Axboe wrote:
>>> +static void io_napi_multi_busy_loop(struct list_head *napi_list,
>>> +		struct io_wait_queue *iowq)
>>> +{
>>> +	unsigned long start_time = busy_loop_current_time();
>>> +
>>> +	do {
>>> +		if (list_is_singular(napi_list))
>>> +			break;
>>> +		if (!__io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll))
>>> +			break;
>>> +	} while (!io_napi_busy_loop_should_end(iowq, start_time));
>>> +}
>>
>> Do we need to check for an empty list here?
>>
>>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>>> +		struct io_wait_queue *iowq)
>>> +{
>>> +	if (!list_is_singular(napi_list))
>>> +		io_napi_multi_busy_loop(napi_list, iowq);
>>> +
>>> +	if (list_is_singular(napi_list)) {
>>> +		struct io_napi_ht_entry *ne;
>>> +
>>> +		ne = list_first_entry(napi_list, struct io_napi_ht_entry, list);
>>> +		napi_busy_loop(ne->napi_id, io_napi_busy_loop_should_end, iowq,
>>> +			iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>>> +	}
>>> +}
>>
>> Presumably io_napi_multi_busy_loop() can change the state of the list,
>> which is why we have if (cond) and then if (!cond) here? Would probably
>> warrant a comment as it looks a bit confusing.
>
> Doesn't look like that's the case? We just call into
> io_napi_multi_busy_loop() -> napi_busy_loop() which doesn't touch it. So
> the state should be the same?
>
> We also check if the list isn't singular before we call it, and then
> io_napi_multi_busy_loop() breaks out of the loop if it is. And we know
> it's not singular when calling, and I don't see what changes it.
>
> Unless I'm missing something, which is quite possible, this looks overly
> convoluted and has extra pointless checks?

I'll fix it.
