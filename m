Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C4453A67
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 20:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhKPTvz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 14:51:55 -0500
Received: from out0.migadu.com ([94.23.1.103]:51916 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235941AbhKPTvy (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 16 Nov 2021 14:51:54 -0500
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637092128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQ2Roqr4t3/SV+7leP8bPNMMTTpbsF9DiwE9Tze497g=;
        b=hBLZ+5jW5zrQLKx2cGehdibCh8NNXWDVRtOvHRI/oggNejYTYbK83V36z/xOUkRLaZbnSc
        gefkDlF0/qn73MDGBlF5pCU80UbtN0QEYq19ysx/MCbXO0EUv6YFi3kMg691OEUhGbKRby
        BuAcIKL0pZknNsf0q01r9SH2nLE6qdimYwfht7pvDh4vH1/tutKIrU8aLoPa47vJH6OOpN
        qpNCJ+jyhj0Coc543slxkimkm/9pUy7vM9K1jyZcNngE8qJARO3A77cQvm57OUq+/gxTRa
        xN9C6GBZ2kDEuP54weWPZqdUmkL+nya5NmXBLpxfUd8SVSjTxEnMfruQKsY7Ig==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Nov 2021 20:48:48 +0100
Message-Id: <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
To:     "Andrew Morton" <akpm@linux-foundation.org>
Cc:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
In-Reply-To: <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue Nov 16, 2021 at 8:47 PM CET, Andrew Morton wrote:
> Well, why change the default? Surely anyone who cares is altering it
> at runtime anyway. And if they are not, we should encourage them to do
> so?

I addressed this question in the original patch's commit message.
