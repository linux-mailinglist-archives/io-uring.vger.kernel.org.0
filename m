Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DEC3B0D3B
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFVSzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 14:55:45 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:35734 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVSzo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 14:55:44 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33440 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvlWZ-0002m9-QI; Tue, 22 Jun 2021 14:53:27 -0400
Message-ID: <b056b26aec5abad8e4e06aae84bd9a5bfe5f43da.camel@trillion01.com>
Subject: Re: [PATCH 1/2] io_uring: Fix race condition when sqp thread goes
 to sleep
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 14:53:27 -0400
In-Reply-To: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
References: <cover.1624387080.git.olivier@trillion01.com>
         <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Tue, 2021-06-22 at 11:45 -0700, Olivier Langlois wrote:
> If an asynchronous completion happens before the task is preparing
> itself to wait and set its state to TASK_INTERRUPTABLE, the
> completion
> will not wake up the sqp thread.
> 
I have just noticed that I made a typo in the description. I will send
a v2 of that patch.

Sorry about that. I was too excited to share my discovery...


