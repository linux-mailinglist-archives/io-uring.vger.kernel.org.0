Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1E1C5F38
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 19:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgEERsp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 13:48:45 -0400
Received: from hr2.samba.org ([144.76.82.148]:56548 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbgEERso (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 5 May 2020 13:48:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Cc:To:From:Date;
        bh=M0P66gTN407+d6oKcb86AA0qCqZU3InlzDHRpphxKbY=; b=mjP7Fwh5fNC3dPOYP2tWBalZ4g
        mQ4UytaBRDXIowy3L3+YDGzFs5x4f5TBxqfwXagb9Op3O7s63onU3kHCuore0zWKc+cBRPRdDF15Y
        bbyuwwfPyhptHWVGiagiefKHSt1AlHvRwWw1KQLvqyr1YyUoRFtXpYo4vPWF1IWW90GEF2WQ51MRC
        WV7N9/ufasUnuK2fuaLMI+4LPt/L/L7IUT4MOy4794r/ivzGKe8ADcsVFRD5bk9gNkwj+CoT8joAv
        E6AFcqIpo5jRf8JFl7igiLnCPOgJmwgS0mVI1jQiqBzhsLO3hvuvesxiCBEOgUGOEBDWe0/5Y+x6E
        f+2Hb8WDNPZeT1NO2egpMdkbrmPBcfcq/25pRZnxhXaD+7VJgx46ubPstCXMFXQU2PhVCzPKx9tmF
        ULG0oD1eEESLHkHobvU/UZhl/xfqIu4Cr4zNzIF2e8gyQW+D2J2oyr4GOrUCRhS1G9s//EmMp6bkI
        NqCSPXzYJLRL+Sspus/L2ss6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jW1gN-0005Qe-Oy; Tue, 05 May 2020 17:48:40 +0000
Date:   Tue, 5 May 2020 10:48:32 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        jra@samba.org
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <20200505174832.GC7920@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <f782fc6d-0f89-dca7-3bb0-58ef8f662392@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f782fc6d-0f89-dca7-3bb0-58ef8f662392@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 05, 2020 at 11:39:14AM -0600, Jens Axboe wrote:
> >=20
> > I'll try and see if I can get an arch binary build that has the
> > vfs_io_uring module and reproduce.
>=20
> Got that done, and I can now mount it on Linux. Been trying pretty
> hard to trigger any corruptions on reads, but it works for me. Checked
> that we see short reads, and we do, and that it handles it just fine.
> So pretty blank right now on what this could be.
>=20
> FWIW, I'm mounting on Linux as:
>=20
> # mount -t cifs -o ro,guest //arch/data /smb

The reporter claims this only happens with
a Windows client, as the Linux and Samba libsmb
clients don't pipeline the reads in the same
way for multiple files the same way that Windows
does.

Here is the bug report with all the details I've
managed to get out of the original reporter:

https://bugzilla.samba.org/show_bug.cgi?id=3D14361

I also can't reproduce the data corruption, even
=66rom a Windows client although I've only tried
so far on my home Ubuntu 19.04 kernel 5.3.0-51-generic #44-Ubuntu SMP
box.

I tried running 2 powershell processes on the
Windows client and doing a copy in both of them
to ensure we are opening multiple files simultaneously
and going through the io_uring module (which I
saw happening by adding debug statements) but
I never see corruption.

I'm planning to try running against a Fedora32
VM next, as that's case the reporter claims will
reproduce the issue.

Thanks for helping me look at this !

Jeremy.
