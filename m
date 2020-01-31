Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF9D14EFD2
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgAaPkg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:40:36 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41726 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAaPkg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:40:36 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so8592844ioo.8
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eAKq2QyfLcdTlNJtYIhV7Qdf7evmCf6D/ZKWaBrIri8=;
        b=1S1ocajOfoVQDsQAePYk/Opj//sSoDraop8mA/wqvw7HxI5ufoDV2lGSTJU2k/AoSY
         R7nradd2LoceUf8E/g5IL5uZek8Vj8BFgKhX0P9FQvuImoBn98U+q3EIv/sOUuuknz/e
         v9SmFuBwc47r+i7bJg0r5Zsnpw3N/TQ/DYFUiVXmozHun7HasvnhyQozVACmQCAPvYR6
         dJZnjtjYA/mavgakmVjEC+h31ojA6JLX6QeY18NXPGuvj/p/kvlWk7R0pJ6fV2a7FzhT
         kB1Dvsuk5KPTECmDE6qylPyZSpTD45G3OdmTTtrKnQtNyC2Lb2WlqtQTNT2US5f3cQyz
         RwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eAKq2QyfLcdTlNJtYIhV7Qdf7evmCf6D/ZKWaBrIri8=;
        b=pJTFnQL+iocdLZQp9AgKFpRlAmE28x8KKxiEdNtgcf+6sF7LH2U8fQenP6s2JS/l3S
         99UDwe58noT3GcQt3XHhlhvfXju3TO5swthdrekIrYk1JbwYHCO+duKmXPUMMw7VwXd9
         QouMMkOZO+vVaocWxKI5dMuXjQJKEx0DRunxJjqBz/FNe22gRWGAyJExwcggXB5HfI/p
         kcR0HODNHf29MF6eXm6I0kfSayZvYaCbw5vnarCIvQ5+stz6SyDOpIigLmHGTDcILdrz
         OWc7ugKn+6fZMfZcyenyBl2g8GSkk9lZHahE7TSNNMYerimzzAdCcucpXvnNGsDb3B4F
         o5bA==
X-Gm-Message-State: APjAAAV6jzAimX5uB8RlzDSnQWbJFjj1C3ZgmjvWSYW/kPrBhzpF17YJ
        BTjr44CwjM93Px7uZ6o5AWwDOkV6jiE=
X-Google-Smtp-Source: APXvYqzYz7i6rV7JzTEJHHWTfdvoJY7wYO7JGAQ4HU+XB2MLO//zG/4xNM03ukNtdnnIuUyw5UC64Q==
X-Received: by 2002:a02:ce5c:: with SMTP id y28mr8949739jar.96.1580485234322;
        Fri, 31 Jan 2020 07:40:34 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h19sm3270800ild.76.2020.01.31.07.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:40:34 -0800 (PST)
Subject: Re: [PATCH liburing v2] add another helper for probing existing
 opcodes
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org
References: <20200131153744.4750-1-glauber@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ddc796dc-0020-5ae5-6f01-15c4c609c8a3@kernel.dk>
Date:   Fri, 31 Jan 2020 08:40:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131153744.4750-1-glauber@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 8:37 AM, Glauber Costa wrote:
> There are situations where one does not have a ring initialized yet, and
> yet they may want to know which opcodes are supported before doing so.
> 
> We have recently introduced io_uring_get_probe(io_uring*) to do a
> similar task when the ring already exists. Because this was committed
> recently and this hasn't seen a release, I thought I would just go ahead
> and change that to io_uring_get_probe_ring(io_uring*), because I suck at
> finding another meaningful name for this case (io_uring_get_probe_noring
> sounded way too ugly to me)
> 
> A minimal ring is initialized and torn down inside the function.

Thing of beauty, applied, thanks.

-- 
Jens Axboe

