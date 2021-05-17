Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01099386DB0
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 01:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhEQXfI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 19:35:08 -0400
Received: from out2.migadu.com ([188.165.223.204]:31320 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235189AbhEQXfI (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 17 May 2021 19:35:08 -0400
X-Greylist: delayed 13884 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 19:35:07 EDT
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1621294429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrYvFqXWqVsq1F590Y+u4jpSu0Wd2fAdKNz7vwJmdG0=;
        b=ZW6MMP6zYkAtyjZsWGgwwh6R0mECSL/gqYzNiKrftN93HWI/0ecGDdEnHyMcgDkd/1XSa9
        cttXRADzGT3ZGQx2WtmcDZ3slRMcVIs05exfP8JH/7fQUEmf00K0LkrEx4wie4yIV4n2tF
        ymUYzR8dYTprjNiI5NynBGsGfwqM3JyMnyaRt0mil2UUuAh5ufoEQd1UNscIEB5lLnMiTS
        VHYuMWc6c86g0UuIw+07isu0HyNxdok0+i2B4z3mXrTmouV8Dd1pevTMkpteEH1fWLIc65
        PXxA1gJp1wSlmw4PNOMptMAPeBHBsMy+xf3qvw0WhuI3TtjSF07EM9q5YezkGA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 17 May 2021 19:33:48 -0400
Message-Id: <CBFWWQBIO18Q.18PQR27VN9NEV@taiga>
Cc:     "noah" <goldstein.w.n@gmail.com>, "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Pavel Begunkov" <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
References: <20210517192253.23313-1-sir@cmpwn.com>
 <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
 <CBFWQ64F7PWU.3EOQ3BQXFHZY7@taiga>
 <7f2c075d-bf3a-7101-23ac-ef63eecb70cd@gmail.com>
In-Reply-To: <7f2c075d-bf3a-7101-23ac-ef63eecb70cd@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon May 17, 2021 at 7:32 PM EDT, Pavel Begunkov wrote:
> > What is the relationship between IORING_FEAT_NATIVE_WORKERS and
> > IORING_REGISTER_FILES_SKIP? Actually, what is NATIVE_WORKERS? The
> > documentation is sparse on this detail.
>
> They are not related by both came in 5.12, so if you have one
> you have another

Gotcha. I'm open to a simple alias in liburing, in that case. I'll send
a new patch tomorrow morning.
