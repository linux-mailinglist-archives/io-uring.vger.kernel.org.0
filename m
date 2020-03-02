Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6EC17656F
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgCBU5g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:57:36 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41196 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCBU5f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:57:35 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so984539ioo.8
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2020 12:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Gl/5rVif2JDN0HnIkWpOEquRYzsAc1gld6y9cprgoeM=;
        b=I4vSuHP/BRg55zuTUMW/zexw/O0mF/VuQbTne2n5EJtnkSqlFx9C6EAHV04aO06fP5
         t/lSP1HmveBtzwhaU0JvFyCz/l0wZx+Ka5V8IhbG/AjSFrodHHWtau9tFoO51623vfNY
         ioqkJIDJzOqaJYbbMbA5U5NrIroH+RSQ6aM6QkMkWjwofDyvunuOuWNfqiOKR4YtwUDb
         tQo/j8xOaceF2A0akGKWwQ4LHLHv/6XZyxjoCPlMk0FswGePTfZseZKjYoywGUDau43B
         ya7XdOjCCqecwKvLddKwCBVGQw9YHcjGb5n6XMYPHBlPOMKJRXISS4M6IwWvQIT6jzC9
         /mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gl/5rVif2JDN0HnIkWpOEquRYzsAc1gld6y9cprgoeM=;
        b=j5OVRsxULJ9RDHEQppnqXhwApeI1B+A7vrOkgxrPie8ldFu5wwnfYygi4OumZnHTgD
         mRdMoqmJKftxKKAIqY/JBmY50aJFNl8oxD1FDOYitvcm6whmMwFk5d5kU17BuoS74p7v
         lHTBTZef54y+usMGiB964CK2tG363M8myh8ppBdaNmqE3SCoBnR9kix81VdNgcBHfd1m
         Xd1jVDW/hJO2fHB2rG7fh7JiWLVKLqkafjAE0Zvu1VB+WZ1mjUoyzDycIXK6gMDWLOsq
         cUisce579CRh5Eb7GQst8NVW3xneb3Gs8hSiibrYIFIpqxlbxJ5MZNNjxxV0bYx3o3/o
         Nj3A==
X-Gm-Message-State: ANhLgQ2GvLjdAOVLY5WoBzWPehpBHzpq56nXUOYTHcq3VUNyGxEj7xTP
        KNBfUpwl6zUB194g4nTBU1bT3nvlGTE=
X-Google-Smtp-Source: ADFU+vssQX8j2SVajfCyyaQyXsHzVhsM6qY+td8eGAaNniD5F543V2zjBUrXXjN3eX5sLxvGoEM+qg==
X-Received: by 2002:a05:6638:18c:: with SMTP id a12mr959281jaq.84.1583182653448;
        Mon, 02 Mar 2020 12:57:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d13sm2045534iln.4.2020.03.02.12.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 12:57:33 -0800 (PST)
Subject: Re: [PATCH 1/1] io-wq: remove io_wq_flush and IO_WQ_WORK_INTERNAL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d29bb1d27f45cb408bd7f530958235b0a4f251f2.1583181133.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1a2473af-627b-7ad8-5ed8-1fae0d15caf4@kernel.dk>
Date:   Mon, 2 Mar 2020 13:57:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d29bb1d27f45cb408bd7f530958235b0a4f251f2.1583181133.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/20 1:46 PM, Pavel Begunkov wrote:
> io_wq_flush() is buggy, during cancellation an flush associated work may
> be passed to user's (i.e. io_uring) @match callback, which doesn't a
> work of a different layout. Neither sounds right cancellation of
> internal work by io-wq users.
> 
> As it's not used anyway, delete it.

Thanks - and yes, it's unused now, so easy enough to just kill it
off. Applied for 5.6.

-- 
Jens Axboe

