Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2D2635F9
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 20:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIS1R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 14:27:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23618 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725772AbgIIS1O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 14:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599676032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=CYZ5JMSY2FFuHVs8u88U7no0/w4MDoHZyXU/VG8Mbsk=;
        b=AbU4vC3WlW+MTqEsCFB0Z6oOf52XGDiwCoO3TSfu79J8XFjCAWiVJzvjNbcoa3MpFCRXwW
        HTNfC1JeOw66BPOlRHMOJqTdC9eQEWuEBqf0lSKydYZ1CJmeewTiXRHtqCIvr+ebkzRArP
        DAhHzDqoVoPMqXj9KWaKj1MNklR4dIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-DTsmZyYpM4ikkz89GyVH2A-1; Wed, 09 Sep 2020 14:27:09 -0400
X-MC-Unique: DTsmZyYpM4ikkz89GyVH2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A4A21DE01
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 18:27:08 +0000 (UTC)
Received: from work (unknown [10.40.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03D7E838BF
        for <io-uring@vger.kernel.org>; Wed,  9 Sep 2020 18:27:07 +0000 (UTC)
Date:   Wed, 9 Sep 2020 20:27:03 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     io-uring@vger.kernel.org
Subject: A way to run liburing tests on emulated nvme in qemu
Message-ID: <20200909182703.d3wjz3rxys6haij6@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

because I didn't have an acces to a nvme HW I created a simple set of
scripts to help me run the liburing test suite on emulated nvme device
in qemu. This has also an advantage of being able to test it on different
architectures.

Here is a repository on gihub.
https://github.com/lczerner/qemu-test-iouring

I am attaching a README file to give you some sence of what it is.

It is still work in progress and only supports x86_64 and ppc64 at the
moment. It is very much Fedora centric as that's what I am using. But
maybe someone find some use for it. Of course I accept patches/PRs.

Cheers,
-Lukas



# Run liburing tests on emulated nvme in qemu

> QEMU with nvme support is required (v5.1.0 and later)!
> See <https://www.qemu.org/2020/08/11/qemu-5-1-0/>

Since not everyone has access to the proper nvme HW, let alone on multiple
architectures. This project aims to provide a convenient set of scripts to
run liburing tests on qemu emulated nvme device with polling support on
various architectures.

Currently only x86_64 and ppc64 is supported, but I hope to expand it soon.

> This is still very much work-in-progress. Use with caution!

## How it works

 1. It takes an OS image (rpm based such as Fedora, or CentOS) and makes some
    initial system preparations after which it will boot into the system.
 2. Qemu provides the system with a emulated nvme device with polling support.
 3. When booting for the first time it will install required tools to build
    and test liburing, update kernel and optionally install provided
    rpm packages. Then it reboots, possibly into new kernel.
 4. Assuming the installation was successful, it will create a partition on
    a nvme drive. One to use for block device testing and the other for a
    file based testing.
 5. Clone the liburing from a git repository and build it.
 6. Run the tests with `make runtests`
 7. After the test the virtual machine is shut down and the logs are copied
    over to the local host.

## Required tools

The following tools are required by the script:

* virt-sysprep
* qemu-system-x86_64
* qemu-system-ppc64
* wget
* virt-copy-out

On Fedora you should be able to install all of that with the following command:

> dnf -y install libguestfs-tools-c qemu-system-x86-core qemu-system-ppc-core wget

## How to use it

The configuration file provides a convenient way to have a different setup
for a different OS and/or architecture.

For example you can have multiple configuration files like this:

 * config.fedora.x86_64
 * config.rhel.x86_64
 * config.rhel.ppc64

Those can differ in ARCH, IMG etc. Additionally you can provide a custom rpm
repository containing a custom kernel, or kernel rpm package directly and
number of other options.

Conveniently the IMG can be URL and the image is downloaded automatically
if it does not exist yet.

Then, you can run the tests for example like this:

	./qemu-test-iouring.sh -C config.rhel.x86_64 -c

	./qemu-test-iouring.sh -C config.fedora.x86_64 -c -p kernel-5.9.0_rc3+-1.x86_64.rpm

	./qemu-test-iouring.sh -C config.rhel.ppc64 -c -r test.repo

> Note that you can use the -c option to preserve the original OS image.
> Otherwise the image will be changed directly and it currently does not
> provide a way to reinstall kernel or add additional packaged once the
> image is initialized. This is likely to change in the future.

## Configuration file

You can find example configuration file in `config.example`

	# Configuration file for qemu-test-iouring. Copy this file to config.local,
	# nncomment and specify values to change defaults.
	#
	# Default architecture
	# ARCH="x86_64"
	#
	# Initialize the image before running virtual machine
	# 1 - initialize the image (default)
	# 0 - do not initialize the image
	# IMG_INIT=1
	#
	# Do not run on spefified image, but rather create copy of it first
	# and run on that.
	# 0 - run on the provided image (default)
	# 1 - run on the copy of the provided image
	# COPY_IMG=0
	#
	# Specify additional file to copy into the virtual machine. See
	# man virt-builder for more information on --copy-in option
	# COPY_IN=""
	#
	# List of excluded tests
	# TEST_EXCLUDE=""
	#
	# Default image to run with. Will be overriden by -I option
	# IMG=""
	#
	# Default nvme image to run with. Will be overriden by -N option
	# NVME_IMG=""
	#
	# Specify liburing git repository and optionaly branch
	# LIBURING_GIT="git://git.kernel.dk/liburing -b master"

## Usage

You can see what options are supported using help `./qemu-test-iouring.sh -h`

	Usage: ./qemu-test-iouring.sh [-h] [-n] [-d] [-c] [-a ARCH] [-I IMG] [-r REPO] [-N NVME]
		-h		Print this help
		-C CONFIG	Specify custom configuration file. This option
				can only be specified once. (Default "./config.local")
		-a ARCH		Specify architecture to run (default: x86_64).
				Supported: x86_64 ppc64le
		-I IMG		OS image with Fedora, Centos or Rhel. Can be
				existing file, or http(s) url.
		-N NVME		Nvme image to run on. It needs to be at least
				1GB in size.
		-r REPO		Specify yum repository file to include in guest.
				Can be repeated to include multiple files and
				implies image initialization.
		-n		Do not initialize the image with virt-sysprep
		-d		Do not run liburing tests on startup. Implies
				image initialization.
		-c		Do not run on specified image, but rather create
				copy of it first.
		-e		Exclude test. Can be repeated to exclude
				multiple tests.
		-p PKG		RPM package to install in guest

	Example: ././qemu-test-iouring.sh -a ppc64le -r test.repo -c -I fedora.img -N nvme.img

