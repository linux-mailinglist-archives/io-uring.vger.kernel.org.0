Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42178390B7A
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 23:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhEYVbW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 17:31:22 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51708 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEYVbV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 17:31:21 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52986 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llecY-0002aQ-Cz; Tue, 25 May 2021 17:29:50 -0400
Message-ID: <35ec5774cc87f1edab72e351b9d2cb0b1457b1e9.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: Add to traces the req pointer when available
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 17:29:49 -0400
In-Reply-To: <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
References: <60ac946e.1c69fb81.5efc2.65deSMTPIN_ADDED_MISSING@mx.google.com>
         <439a2ab8-765d-9a77-5dfd-dde2bd6884c4@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-05-25 at 09:21 +0100, Pavel Begunkov wrote:
> 
> Btw, I'd incline you to split it in two patches, a cleanup and one
> adding req, because it's unreadable and hides the real change

good idea and I agree 100%. My git skills are a bit rusty but I am
going to take that as an opportunity to learn how to submit a patch
like a real kernel dev.

Give me a couple of hours and I'll send a corrected patch set.

Greetings,


