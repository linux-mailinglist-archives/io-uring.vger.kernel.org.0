Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7479D75FD81
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjGXRYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 13:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjGXRYj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 13:24:39 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2302A10FF;
        Mon, 24 Jul 2023 10:24:36 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 65DD4320092B;
        Mon, 24 Jul 2023 13:24:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Jul 2023 13:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1690219473; x=1690305873; bh=30
        d8X/GI+G1ANrMbLmCjOU7CaE2R2Mm48/9tj9s2I8A=; b=C6ZNKY39Fw2fwKdmp7
        61uj3cvlHl3zte9Tb4CHQ7+wlLZnd+mpisveVfsON8lOU16q5M/rdjssjmOirM/T
        gz0d1vFbHHM81KtWT404B6oKJRB+5f8MmEmMLP8u8tJuIPpSKcWOqKIKLTd+c942
        VKqWvFG2v8NACch5r6uzvNVmeoDgt9+CodKvlSMXXeKrx+Vr4XiruSdHRI6Bwfyg
        iczBpKKf/+VfVRsiP25SxChF2tRyrN8tjfPJdfip9EqW1qD5FprAhzIOgJ/YfPbI
        /E7oLWeQwGx9sN03pKtaqMGKpbL+h+mTPGMFIdmseoWBLrWg/hUDGJXx66p+tfHB
        vEaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1690219473; x=1690305873; bh=30d8X/GI+G1AN
        rMbLmCjOU7CaE2R2Mm48/9tj9s2I8A=; b=Mh0kJmgCBxwX4CMM6yDPlNASUNrFV
        rf8y397rWesi44R6Dv8ha22GliUxMPZDBP/mrdV4FSA0d/e9XtQlz7exBnksVklY
        vpNSqVR5ANGebLLKJn5TQh48oVqVH4apyaAxvpB/r0mhaX15GsFKoptAmL319f5z
        bWzZnt+Wv4B8FEiwm9BkDU0hK3hoNS3w4XjwbUka6azVGm2seM1+yXHfM0rH3wbO
        qohYUN0BtwV0S44tnLRfNFAElwiuxKWODqsZ/vc1MJ+VXjtabq4MennrrAS2w3ru
        db6yRapeeT8fcR12Wg/zjjv/1y5RMB1YF7cJGYwwY7D1bhg0hqBih6UVA==
X-ME-Sender: <xms:0bO-ZBbvGzTGZQ3fhfirj8XeBjdLV2Bf5Q2xu8ynddlmKTxhDbT_Gg>
    <xme:0bO-ZIas8AxvRa8AcbS7ROakpprdMcmlZpf_1lKKIjTsI3q41Sz7PKqq2q4EBneja
    PydZjmLBjRZ5Ng83Q>
X-ME-Received: <xmr:0bO-ZD8xYvToLzRDO4XtFTS6NSlFW9q9noR3UPav5Mr9BTt0O4gULuySHjsW5u93tj6uHlNSK-sGaOBqKcu-SUkoee0qYk5aDWkGtSorTBaSyWduaXiIbJEEzcRU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrheekgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:0bO-ZPr9BJPAC2vIu-QuK06pYzU8JDYri9V2IJ978q-hHbU20-iu1Q>
    <xmx:0bO-ZMqDCkCsq-Ieel64Gawbkyo6QbVr3b8EkffmKaAfzeWYPu27lQ>
    <xmx:0bO-ZFQ1AOJEKCyiN2aVWLycW0VhgZql6-EtB5qfqaevnfmePSnCQg>
    <xmx:0bO-ZEJklolShpLKKGoiWuVH8FEIb_b-SpRAPyaEW2IBMnDgVm0yvg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jul 2023 13:24:33 -0400 (EDT)
Date:   Mon, 24 Jul 2023 10:24:32 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Phil Elwell <phil@raspberrypi.com>, asml.silence@gmail.com,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Message-ID: <20230724172432.mcua7vewxrs5cvlg@awork3.anarazel.de>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
 <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-07-24 09:16:56 -0700, Andres Freund wrote:
> Building a kernel to test with the patch applied, will reboot into it once the
> call I am on has finished. Unfortunately the performance difference didn't
> reproduce nicely in VM...

Performance is good with the patch applied. Results are slightly better even,
but I think that's likely just noise.

Greetings,

Andres Freund
