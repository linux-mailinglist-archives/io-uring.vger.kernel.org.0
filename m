Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379C234292D
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 00:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCSXrU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 19:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCSXqy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 19:46:54 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C54C061760
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 16:46:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v3so4740598pgq.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 16:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=+1hnJPoFtq8ENpAO62r/Z7bTSmw4qHlVk/XM9Beaq1k=;
        b=Px6Ubsl16skHQ3jqqt+yQhkz/cR+Cup5MkKfxzj7Kp+b35Zkd3sxnbYJPEsyJj3ymp
         9uqF4wj8wjzUhkUQ8isn+urb3tiPKXIhr7Jk5fc+ukbwzAIdpQfyhTw9O1GB3XDXABBq
         0mYic10dKTr+86vj/oex1TulpA93mGSDiUizRvjYRRMGKInYKYrhPgt6LPMn1zQ0eSRQ
         c0fjjh15NoMC95CQk8EgeS9WcpftXVAc8n82XHjhj18LUqCcbYnzjXWRXd3MEELL9L2Z
         oJr14Cx4srTlDWerqJBy1KICBEnZK6nK4YzpTnqHUsLsQL6EToBmR85PpP2mfVwZUyzU
         mIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=+1hnJPoFtq8ENpAO62r/Z7bTSmw4qHlVk/XM9Beaq1k=;
        b=nLGnRCidG+821ROBkS5LUQo9YaqPU/109BcyniMx9y52dVL3tEA9y2ja0g6XH6kCve
         wRGHR7YBuewUqJilkoJ8wsFKxo9NZbknN8iSvarcFGI6MgvHPQSBKux4jRrgVkbRollJ
         UECC5eu5lQOFZjPmvuunkxjTza1kB/+P99dGDaA0lXZoXIWmT9EMiA+W7i3hsrozS2Zj
         zvqOsTVOzyqV6aaA+8cdq583LJl9a3yDYd2ib2RI+7uwCoqSEGzxAqwITel9K4EgDLRK
         UfbE7JQJ0+iyWuk2XevpUgJFKCpUKpzPnWSE+oNICmHX+s546dBMzKh/Q3/Gh8WXvAYL
         OPZw==
X-Gm-Message-State: AOAM532C2Z5YiVg74LP62lsAqaottb8EHHsq6J+DF/RJr38WzSE7/JFn
        HKWRufmvM1K7gXBIU4yLStCJbYMzXXoKWg==
X-Google-Smtp-Source: ABdhPJyQWcLv6ey6PfbBGWgxkXvEW9r5fW95+fLhD55psvzcj/iaJ99eM9NOKVg6NhMFMnWQOcKGhQ==
X-Received: by 2002:a63:4c20:: with SMTP id z32mr13063615pga.377.1616197613647;
        Fri, 19 Mar 2021 16:46:53 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:4a32:8385:e03e:bb5d:352a:b5ec])
        by smtp.gmail.com with ESMTPSA id a204sm6699783pfd.106.2021.03.19.16.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 16:46:53 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: Problems with io_threads
Date:   Fri, 19 Mar 2021 17:46:51 -0600
Message-Id: <F3B6EA77-99D1-4424-85AC-CFFED7DC6A4B@kernel.dk>
References: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <d1a8958c-aec7-4f94-45f8-f4c2f2ecacff@samba.org>
To:     Stefan Metzmacher <metze@samba.org>
X-Mailer: iPhone Mail (18E5178a)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mar 19, 2021, at 5:27 PM, Stefan Metzmacher <metze@samba.org> wrote:
>=20
> =EF=BB=BFHi Jens,
>=20
> as said before I found some problems related to
> the new io_threads together with signals.
>=20
> I applied the diff (at the end) to examples/io_uring-cp.c
> in order to run endless in order to give me time to
> look at /proc/...
>=20
> Trying to attach gdb --pid to the pid of the main process (thread group)
> it goes into an endless loop because it can't attach to the io_threads.
>=20
> Sending kill -STOP to the main pid causes the io_threads to spin cpu
> at 100%.
>=20
> Can you try to reproduce and fix it? Maybe same_thread_group() should not m=
atch?

Definitely, I=E2=80=99ll go over this shortly and make sure we handle (and i=
gnore) signals correctly.=20

=E2=80=94=20
Jens Axboe

