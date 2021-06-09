Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228AF3A1FCC
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 00:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFIWKG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 18:10:06 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:60224 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFIWKF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 18:10:05 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51962 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lr6Ms-0003IZ-AZ
        for io-uring@vger.kernel.org; Wed, 09 Jun 2021 18:08:10 -0400
Message-ID: <139877a766ff10a112cce3d15bb738bb6461196b.camel@trillion01.com>
Subject: Re: Possible unneccessary IORING_OP_READs executed in Async
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring@vger.kernel.org
Date:   Wed, 09 Jun 2021 18:08:10 -0400
In-Reply-To: <6941451d3471effb5b5b7038164fe6b9c1a6b5a2.camel@trillion01.com>
References: <439fa5114eb2bf0914e11c2a0c97798885c7d83f.camel@trillion01.com>
         <6941451d3471effb5b5b7038164fe6b9c1a6b5a2.camel@trillion01.com>
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

On Wed, 2021-06-09 at 18:01 -0400, Olivier Langlois wrote:
> 
> I didn't wait for an answer and I went straight to trying out an
> io_uring modification.
> 
> It works like a charm. My code is using io_uring like a maniac and
> with
> the modification, zero io worker threads get created.
> 
> That means a definite gain in terms of latency...
> 
> I will send out a patch soon to share this discovery with io_uring
> devs.
> 
When reviewing my patch, keep in mind that I have only tested it with
IORING_OP_READ... It might not be universally applicable to all
operations... I haven't tested beyond my personal io_uring usage...


