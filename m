Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C871C7DA8
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 01:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgEFXCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 19:02:50 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:15917 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgEFXCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 19:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588806168; x=1620342168;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=4wKajfTvHFSz5VD/SDsMby3SztT6VEYGUT2fzAOg5xo=;
  b=TdS+Jh2SZMWlOpJ6aJ4KX36PT6hpvg2WWGjOrT8C3zuYtJ2Qk63DAr8z
   32IImVwfuSRFhTgTSOmKSSjzy5dUDrQxUNTBLvIw+utKLjAFqLh+E0PA/
   r4/2aICmSnqbqRRjXkxT6EjW9zG2zkDrx/6ofak9Ye+nvn4LayARKUmmz
   U=;
IronPort-SDR: TZ8VPx4LLT06dEL5DcxmKHhCpYEdCy+++e3E2ESvkc3AJlskTeYiYaPGBqeD6WgvUbGgRO9iHv
 8jCdNgGwW0xA==
X-IronPort-AV: E=Sophos;i="5.73,361,1583193600"; 
   d="scan'208";a="33441773"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 May 2020 23:02:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 45167A20DD
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 23:02:47 +0000 (UTC)
Received: from EX13D10UEA003.ant.amazon.com (10.43.61.26) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 23:02:47 +0000
Received: from EX13D14UWB001.ant.amazon.com (10.43.161.158) by
 EX13D10UEA003.ant.amazon.com (10.43.61.26) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 23:02:46 +0000
Received: from EX13D14UWB001.ant.amazon.com ([10.43.161.158]) by
 EX13D14UWB001.ant.amazon.com ([10.43.161.158]) with mapi id 15.00.1497.006;
 Wed, 6 May 2020 23:02:45 +0000
From:   "Bhatia, Sumeet" <sumee@amazon.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "Hegde, Pramod" <phegde@amazon.com>
Subject: Is it safe to submit and reap IOs in different threads?
Thread-Topic: Is it safe to submit and reap IOs in different threads?
Thread-Index: AQHWI/pY8QGyZIkT0UiwkbSg4xdfjg==
Date:   Wed, 6 May 2020 23:02:45 +0000
Message-ID: <1588806165324.88604@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,=0A=
=0A=
My application has a thread per disk (aka producer_thread) that generates d=
isk operations. I have io-uring context per disk to ensure iouring submissi=
ons are from a single thread.=0A=
=0A=
producer_thread executes only if new disk operations are to be submitted el=
se it yields. It'll be significant code change to modify this behavior. For=
 this reason I spin up a new thread (aka consumer thread) per io-uring cont=
ext to reap IO completions.=0A=
=0A=
My reading of fs/io_uring.c suggests it is safe to submit IOs from producer=
_thread and reap IOs from consumer_thread. My prototype based on liburing (=
Ref: https://pastebin.com/6u2FZB0D) works fine too. =0A=
=0A=
I would like to get your thoughts on whether this approach is indeed safe o=
r am I overlooking any race condition?=0A=
=0A=
Thanks,=0A=
Sumeet=
