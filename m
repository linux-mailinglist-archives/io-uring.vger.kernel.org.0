Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFDBD14010E
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgAQApN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:45:13 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:39089 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726378AbgAQApM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:45:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9A797333;
        Thu, 16 Jan 2020 19:45:11 -0500 (EST)
Received: from imap21 ([10.202.2.71])
  by compute3.internal (MEProxy); Thu, 16 Jan 2020 19:45:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hZKYxd
        lu8iUVwDGCPOiaxkgzSUeyQwWC0ibxsczROtc=; b=G8kHDlU0inkLaqUZnH+MHR
        rqDK8PT0vfnpq9CUqyic6fPPBIwKM94WZHrNqFff1S/BLD3kiPj0W6vEFzlReL08
        ynNRheuFL13tdHGVMidoDy2Uc92MMD+lgW5BQV/oTyrmcpBMAHaF4pMe+Qbw+7bQ
        Z10yOHC6A4D7I9bgSp6HxPTIa1GGEG+5V+gMb5zHs2GZmOgZlXJREMbHkDblNejM
        gh8GpN1To2ozm6Wr2wMyy1//wko7qPBjaEKq7RgwmdcVNxR83AW5g8qrvbeqdMow
        pNlYXpKyiLr65JCBezU4udEZ7dSeFhJVbz+z67RCHPT+kebGi/3NX5+MjbpJq8qA
        ==
X-ME-Sender: <xms:lgMhXnN_5TUOb3pdZhCQyzYk0eOzXev9ZbtBDBargS5b4Fm2l4gWDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdeigddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfveholhhi
    nhcuhggrlhhtvghrshdfuceofigrlhhtvghrshesvhgvrhgsuhhmrdhorhhgqeenucffoh
    hmrghinheptggrphhnphhrohhtohdrohhrghenucfrrghrrghmpehmrghilhhfrhhomhep
    figrlhhtvghrshesvhgvrhgsuhhmrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:lgMhXl-Gz52Pb9duq7gPIdD_wiyNML5kjvPK_n2ZaOKlJ9wsxNFyqA>
    <xmx:lgMhXm7FWbkP0JyiNt-wctMPqaIy7PV6feE7blQ3Y__BvTWSd7BfKw>
    <xmx:lgMhXrkxBY3SzdakBYcWw8ahTBAJN2S8m2Sod2hlvhHgaAwEGMjn-A>
    <xmx:lwMhXviYz0cw5sdM0AnE5gN9O3JsqGIGWPOZijHTTlgIS6XBNUG-1Q>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9F5F4660061; Thu, 16 Jan 2020 19:45:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-754-g09d1619-fmstable-20200113v1
Mime-Version: 1.0
Message-Id: <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
In-Reply-To: <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
Date:   Thu, 16 Jan 2020 19:44:49 -0500
From:   "Colin Walters" <walters@verbum.org>
To:     "Stefan Metzmacher" <metze@samba.org>,
        "Jens Axboe" <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Thu, Jan 16, 2020, at 5:50 PM, Stefan Metzmacher wrote:
>
> The client can compound a chain with open, getinfo, read, close
> getinfo, read and close get an file handle of -1 and implicitly
> get the fd generated/used in the previous request.

Sounds similar to  https://capnproto.org/rpc.html too.

But that seems most valuable in a situation with nontrivial latency.
