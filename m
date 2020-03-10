Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8E817FCA0
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 14:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgCJNWM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 09:22:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35764 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbgCJNWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 09:22:11 -0400
Received: by mail-io1-f68.google.com with SMTP id h8so12720169iob.2
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 06:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lFu315JPMb6LS7czi1EtwU31+XoAlRGq+kPqijlPodM=;
        b=ZhZXVUtgIS9Q4AR9H742GPvO6BDOoWtNJcceD1o7fM+uY9XrwJZy+vG8uIqfNrPbLb
         +o/gKLGW6fbpX518IQ5ypBWDqg4OCuUOucVZ1Djc6VcNef+A+uka+hhYP0FrdKjNLxrM
         LlE62bXMY4nQsSCDj0+w1Ew3DljeMeteHB40EWfre2/lb7ikkV7zQfpKw9oA8f26D9aj
         EIsAHnkUcz+0QJ9avfOROz5prC9g15hTT3tT5Elg3ltyyWSYIDSMCUPDnDFlU1uWNmZ/
         uDoZbulp56M+S+BaWRPqPNrI8dNKDsjP7VQX590k9lJrC/Q/TntSRlctxWcXrYkulaeE
         8nJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lFu315JPMb6LS7czi1EtwU31+XoAlRGq+kPqijlPodM=;
        b=HUfuGuo83HSEy4vsH6/SVCahVNzhtnH+nmAIE57CWgTRoGeQFeZ8xXRrg9eVXtQ6M/
         2dI3LkJO//yXhLLIXFdCCAhYQBERAOehSAhuZ8ynfKcrQODnHubujW+yywembAgxwzwF
         lC2gYqwMC6QxKMQIBDrZ3eFV55cbaKs4+erwR87INxiNoWgG8oYLeHjO2rpZOO342DT3
         zWn6+orffNQlXI1ZKbI40qChq8i5l6FlMXDH4VEYaoqgRXnE2l87FuXvb5zxTcyeUciz
         awzdm7OlSNuhPOe1d7rr00EE4e3nuDlMEeR/1mWYjyc/yor9bzaqixB2jPuZPcypJuKE
         QMKg==
X-Gm-Message-State: ANhLgQ1CND9/43Ujrgtpf2Mia6vLNjWoN3ZNzj/eRf1f9M1886XXtNaX
        sqY8GbRUL2G8on21iWYX7/Py8J1ooJhhaA==
X-Google-Smtp-Source: ADFU+vtnfntW1NuwT/Flser42nIEFGny8d85SJRu6SNJzcqFlMyJX41eVW0BYUsOS/BLfUTBfIuGzg==
X-Received: by 2002:a02:cc84:: with SMTP id s4mr20232059jap.5.1583846529569;
        Tue, 10 Mar 2020 06:22:09 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e3sm7644678ild.34.2020.03.10.06.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 06:22:09 -0700 (PDT)
Subject: Re: fsync with SETUP_IOPOLL and SETUP_SQPOLL
To:     Ashlie Martinez <ashmrtnz@cs.washington.edu>,
        io-uring@vger.kernel.org
References: <CA+KEPO_-7woKF=eNV0jnuT+JOFW43im3dxzZMJTuPbSns638pw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4de0f831-84c7-2641-fa8d-3ba5b8d61c42@kernel.dk>
Date:   Tue, 10 Mar 2020 07:22:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+KEPO_-7woKF=eNV0jnuT+JOFW43im3dxzZMJTuPbSns638pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 7:31 PM, Ashlie Martinez wrote:
> Hello,
> 
> I am playing around with some of the newer io_uring features on kernel
> 5.6-rc4 and I was curious why fsync always returns EINVAL when the
> SETUP_IOPOLL flag is set when running on a file system (in my case xfs
> since it supports iopoll). Is this because you expect all changes to
> already be persisted on disk already? Do the assumptions change if for
> this if one is using a file system rather than a raw block device (ex.
> would I also need to use O_SYNC in addition to O_DIRECT at file-open
> time)?
> 
> I am not super familiar with io_uring and how it interacts with file
> systems vs. block devices, so any insights would be appreciated.

Polled IO cannot support any operation that needs to block for
completion, as the task submitting IO is also the one that needs to find
and reap completions. That's why you get -EINVAL when attempting to do
so.

You could potentially have a non-polled ring that you use for fsync in
combination with the polled ring. At least that would be one way to make
it work.

-- 
Jens Axboe

